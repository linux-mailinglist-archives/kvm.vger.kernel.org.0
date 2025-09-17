Return-Path: <kvm+bounces-57838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8166B7E472
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:45:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 941821C07C76
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 10:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A576235E4F9;
	Wed, 17 Sep 2025 10:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xd/lKoFg"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011029.outbound.protection.outlook.com [52.101.52.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2895035A2A4
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 10:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758104240; cv=fail; b=Y8RqVezX8qq1kmX1wo8XmemAOsPsqxrGxXyrZZBwQuNA/+9lM+c3GfNOaEYSTEZl8/xWflwITIRpH6G0P8vUM6CyYbwvSLE8yqmSg2Z5BTAlElT4z8Vxc6dHqarhVq1j2Uk8tGJDAIukOOi6GTTLqBt6Zl75HQdC++pnJqz29M4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758104240; c=relaxed/simple;
	bh=sRoQ4i3+h2ugK/MWhb+Fu5yA/nBnOsvdzDH7wTvQEZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XrXInEan3mtYZyQd+x3KueNso0kFCLyKQu+n7ie2QFvFNuSCJW5VGFHKLLPCib3DPICxp5QIO4LiLcZXaTiWC1m+kejEJY1lqRoR7tDJMKMbxTNuDg8G77nWteIkcj0S8h+49c3FPI0H4zdK4nFmfKUbRVhjtCBbBZvqnLWGhcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xd/lKoFg; arc=fail smtp.client-ip=52.101.52.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mTJVlOQewSuTpU3VIzUyHtqzeb+GoS4uMn5egPp9LaxUUEdcT0Hoqz6bvTnxuC5LKVZrvK/8s+5AlH0TVp65u6i0NHsJqr5Uclm4jYYfHCQbZ1a9MDBr45nGLJft7PmaObhL2XRBcNNMYmytmerZb9RPtTQ15nnlfDsrKPLuWCyXGf6aUaML0Nt5pbxP6QClLsMpau7VG5LADEaIFgqWu4rZnPNW6ycBzCc4cJonrwOBkiMBA1F2wU/CNA5SPZW3+hkkMfkkFFPJU4vvmuUx7PGcPA+h9RghkgJQOm0TWf5GAezV7K5pLELFuTMHXS4p+4HNA3v+DNZ2Fybl0vpPWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztdp+ZKtEyCDyQ3mYXUEXwCp3CrItVxmFAFYJJkHadg=;
 b=dEH/RKVZb6GyxwqdJnFG7dSzP6aQnBeKMgMZxKtqvh66M6A4b2o9oSVmQhXc9iu9QfCsBSWSiYxPvyq4FCnlU2IzpAJjPSUBUSQN4cQLEf41l/GCFWiH0SByTiSPRm0A6jlZpKFVecUVUUiGpdjQ0sXZM8lNq8XkDnF85eshL/jLwrS+hNHiCisRF9Ehykcf5qb0898C58EcAmiFpZwQoQbh7NcpaLkypFSIe9zScUCO1Nb++v5a6DcRAWZuNAIHfGnl/hO6XTryR/TNoqEQzBjDDX4GQmkU1v7QhHvDm3HRRHOQiRnSn7+LShICw7TUHRgX3B/HVCvnkllnm9WqYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztdp+ZKtEyCDyQ3mYXUEXwCp3CrItVxmFAFYJJkHadg=;
 b=Xd/lKoFg7in7Cqeqw3aGWTpgqBF/5lJltPUmx7v8z4EkWKWEXgmTqaDAKA/dg8HdXnLJUtoEEn4dddSGuIFdwXI3SGYaAVtNvlTnnQ/+JHEtWT5iky8mGpwlJtsAWe7ivz3lxaojBHPTJ+XH6iRtPRdrlnvXSawL60G3GWryXo8=
Received: from DS7PR03CA0162.namprd03.prod.outlook.com (2603:10b6:5:3b2::17)
 by IA1PR12MB9739.namprd12.prod.outlook.com (2603:10b6:208:465::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Wed, 17 Sep
 2025 10:17:11 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:5:3b2:cafe::5d) by DS7PR03CA0162.outlook.office365.com
 (2603:10b6:5:3b2::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Wed,
 17 Sep 2025 10:17:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 10:17:11 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Sep
 2025 03:17:11 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Sep
 2025 03:17:11 -0700
Received: from [10.252.207.152] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 17 Sep 2025 03:17:08 -0700
Message-ID: <7d7c3d4f-eb27-49a4-91ad-b6c3aef17237@amd.com>
Date: Wed, 17 Sep 2025 15:47:06 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch
 structure
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250915085938.639049-1-nikunj@amd.com>
 <20250915085938.639049-3-nikunj@amd.com>
 <fa0e2f42a505756166f4676220eff553c00efb1e.camel@intel.com>
 <80fd025b-fd3b-4cf1-bcab-20d5b403666a@amd.com>
 <5e6c276181bdfab55de1e5cd5c0d723e76cfbbea.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <5e6c276181bdfab55de1e5cd5c0d723e76cfbbea.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|IA1PR12MB9739:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e503da1-7756-4759-a2f1-08ddf5d35dac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MGt0VWtaSnpGempuVVVodmtBdjJCOWs2RDZDeDlrSDB6c3IyT0YwRVVsbWQ0?=
 =?utf-8?B?U3VUSWFwc0xZQytjUTdRY0EvY0hlaSsyVXRKRTM2OHNTeGRUdmVqTTByVnRS?=
 =?utf-8?B?WFpxaGNqRkFQRnNuaDgwb3hzZXVXejlEaG1IQVZLeUFFRElVYXdRbHRZT2pH?=
 =?utf-8?B?ZFlXTWpGS0VUamh0cXEwbHpkOFMyeHFVcVhQV0xNYzBzenk5bEtzakZLQ3h6?=
 =?utf-8?B?NkIzV2VWOVdjTHJQWnJReGNabjJoQ2tNZnRJRWFQRzhvZDN3dEVhdy9tRkJ5?=
 =?utf-8?B?eXBZYTJrckhsMnZJM0psckRjOFRZdVZrVm90S1J3S2QwUjhMbWdYbWJHZm1T?=
 =?utf-8?B?M2hSYlZPRHRUT3JZQUJmbFU2NFJ0S1NVWTlyN3pUclpvNkR6KzB6MUY5b1J2?=
 =?utf-8?B?WGFSUTcwU3lvUGUxVHdINWxjS3haY0h5K3V6endUWTNCTStlOW9sdXEzT3RN?=
 =?utf-8?B?aGFtK0M5SldmNDZ2ZlJuMitlUlB4bC9jT2dEVzRVM0pPTjFZSm02VGU1bFZa?=
 =?utf-8?B?S2dEWktJNG1aSkZKcVpCblZ2RTdvT09XTmRMNzd6UmhFTkpHbnFWSnRIWjBj?=
 =?utf-8?B?am1wWkNiUERJK2tKYUNZVm1nVEVJSlE2T0ZJQ1htQVBBODJTWE5lNklPM0NX?=
 =?utf-8?B?bWNBOHJzMW5HTThMcVh3Y1VhYWdBV0E1cFE2NDFOWWhQS3lLQ3IyakJJU3py?=
 =?utf-8?B?NDIrR1I0bHYwdk9LdFRrWWZ6MkRabXAyL21QVVp5MDVDTmVZSXdYaFZmWk91?=
 =?utf-8?B?c3YybFJwSTNqc3lZOEh0a0tkMTJkZkdlMFN0OXlwcCs1L1lVajl5WmttdVF6?=
 =?utf-8?B?MUdHWW1pa25JVHRiVmdqYStUR3Fyb0M0bUh5bHJxaktkZzg2ZTN3N2VqWVFB?=
 =?utf-8?B?SHFKV2FqVEc4WDJoT2MyaXd1aEhzUEdCUXhVbThFYzgxVmQxaksrS3BQdG1I?=
 =?utf-8?B?UlNWR0N6dXVWQ1hZV3pPNjhZdzQ4NjVQSExsbWRIcm9Zd09weTZOczgzRlBL?=
 =?utf-8?B?Sks2UlJNN2NxR2llb05FSnJUTU1ETEUyb3FNKzU3azFiSHNBSlphZUh2RzVn?=
 =?utf-8?B?OXRZSlJ0RnRkY3lCOVhBSEpocXY1NUJRYTZuaFNyYnF1cjZ6OFdCRWdWbW1G?=
 =?utf-8?B?UFp5b2RuN284S2NlQTA0TndvU0dpQlVmRmNhVkFPV1B5RFRZOVNpZENTckpo?=
 =?utf-8?B?eUVrd1pJa3g0V1pEU2EwTGlvN0NtdTFLdWdUMlVLYXlLcUNIVTV5c3hjWkla?=
 =?utf-8?B?YUpOSjFQdlNoOXNxY2JRWUdtbGhPZUdieXBpL2dCbXNuWlRpTm93Q0tFWllz?=
 =?utf-8?B?WVNiNmRTM2FJUTBKUC9odkQ1MnFLc0VodnRXdFVETkdSNkh1SGhqdmhBeEdU?=
 =?utf-8?B?ZmYzcmxHcnhJOGFOVXFOZE9Bcit5NFU4bnU2ZUxJVXkyelRoZ0RKS3FvTlJE?=
 =?utf-8?B?QkRTcGNaOXN5b1BmZTVzWDRVK2VIdi8zc041TTRQR3NqVlVrL2NlRzgxelhH?=
 =?utf-8?B?YWpTSjErWE9aQ1JZdUE5OENDSmdkOVJTYjJxUklUR2plZlhMSFJGelgxZm5C?=
 =?utf-8?B?T3cxcmxaZGFCMlZLbERBZTBidElWZDMwWHN6U0VBcW5PRi9DSzUvTUFGOVRv?=
 =?utf-8?B?ak9aTzFvb1hNYXRZMW4veWlXRE9BRk9iMXhTN3pCUThHVU5HeTdlaEp3OS9E?=
 =?utf-8?B?T2U0RnhZRjFZV2ZPeUxSSGF5eTdQZGtlRkVncUhLQjMzTFZMVktLMTNVMkE1?=
 =?utf-8?B?R2p1b3lIOFN5UU1VQmhNTkVYd2lQenhQWXd5N2s3RlBRYU9pYVpLZTJqZ01Z?=
 =?utf-8?B?YzhaejZaZTN5d3lBUVZ4S1gycmVsWnYwOHBYR0dvSWxPeHp2OVNJbGF1QTY2?=
 =?utf-8?B?b2Y0SUEvVnUySi93T1M1cnJNalBDQ0FhVFNSUGU5bFc5ZFM5MmxDZ2JMOXpt?=
 =?utf-8?B?N0ZDOE5USVdqOUN3bTFXZ2hOaXovVHVEdzZOckRnYUxCUFhmdzBVWFBpS1JE?=
 =?utf-8?B?aDJuZnBPbjl6dmlEYzljQW9IU284NlVydkhCV2Z0RDZwSytXcDFwMTVCbTZN?=
 =?utf-8?Q?wDyXDs?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 10:17:11.4177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e503da1-7756-4759-a2f1-08ddf5d35dac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9739



On 9/17/2025 3:43 PM, Huang, Kai wrote:
> On Wed, 2025-09-17 at 09:01 +0530, Nikunj A. Dadhania wrote:
>>
>> On 9/16/2025 3:57 PM, Huang, Kai wrote:
>>> On Mon, 2025-09-15 at 08:59 +0000, Nikunj A Dadhania wrote:
>>>> Move the PML page from VMX-specific vcpu_vmx structure to the common
>>>> kvm_vcpu_arch structure to share it between VMX and SVM implementations.
>>>>
>>>> Update all VMX references accordingly, and simplify the
>>>> kvm_flush_pml_buffer() interface by removing the page parameter since it
>>>> can now access the page directly from the vcpu structure.
>>>>
>>>> No functional change, restructuring to prepare for SVM PML support.
>>>>
>>>> Suggested-by: Kai Huang <kai.huang@intel.com>
>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>
>>> Nit: IMHO it's also better to explain why we only moved the PML buffer
>>> pointer but not the code which allocates/frees the PML buffer:
>>>
>>>   Move the PML page to x86 common code only without moving the PML page 
>>>   allocation code, since for AMD the PML buffer must be allocated using
>>>   snp_safe_alloc_page().
>>
>> Ack
>>
> 
> Btw, just asking: why not just merging this patch to the first patch?

Just kept it separate as VMX and SVM is not sharing the page allocation and 
if we do not want to have this churn of moving the pml_page to vcpu structure.
We can drop this patch.

> I don't have strong preference but seems patch 1/2 are connected (they
> both move VMX specific code to x86 common for share) and could be one.
Same here, I can squash this with patch 1.

Regards
Nikunj

