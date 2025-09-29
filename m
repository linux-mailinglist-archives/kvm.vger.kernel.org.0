Return-Path: <kvm+bounces-58961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DF0BA875D
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 398981C0A8B
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 08:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6406F27EFE7;
	Mon, 29 Sep 2025 08:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MKMR3Lik"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011034.outbound.protection.outlook.com [40.93.194.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F9D27CB31
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759135951; cv=fail; b=Ysw5z+EJoLPspqW/q+JjaLqQyG9KwzRxisJaSsJ0m2Y0RgSuACwbcauxYIuX5wajaG18Gr9aO/+oTJp28hfvob7EFrlWaenc1JHXmptD8x8nv3P3UZCEYeTNqnK3ilZLQHaGzfkrOHZfWv/mkXoA/yyvN+mG9kBFJDaZEY6pzkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759135951; c=relaxed/simple;
	bh=bdmmEYZdn8Zg7dZHhZf+B2q8JI//LartPIrUT/GK1ZQ=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:CC:
	 References:From:In-Reply-To; b=u3gyMS8kc1dSvgFDceFreXhVZgxeSr402mhU3kivWR89+KoDZexGsHw6FaWMrj9EJpaL07J0xXXoTfUu7t/nlaQEIdBPcdM1jM8QDBC6f4rVV2HLLMn3x07DPmMumEjOk+csU3c1qf+SE8LKv7oL4Fuip5X45EwnWkxqJzuAAoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MKMR3Lik; arc=fail smtp.client-ip=40.93.194.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/xHXWkXPhTDCqWTrYpnH2whPav7W7LPms7aeEN5pi2g90UyQIIoX7zbGIX3OF/J36/qnBSqT+qay/1iAdHN9RLetuwrxCUTNTFLvetXZL9FUQ6WI1Lt/8WfUgKW3CEcqNWqXin2eDQxs+WawIUcX9n+3YeE+2tV9sV+2h209SlZO4Eqp9zmo0VIAYPL1sXNfCTG3gw+Z2v7AjMr7zCxvic+o6CoOlDJc2Y/RO+KTReSQO9mm6oiVOYZVDugDn5wyzSQXkWXgdhASblXecjuBoGh3ILv7YGjHCjDPNvLl38uz6yW1XGD8AdGvMqbtGGUnYXmA8uE3+N6yfCSdJrjuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orQC5QpgrOXr5SSPwXcz20llPIV/XCjUZG3+ZWvwI+M=;
 b=fKXcwJmbHkKmyG0tcEF0oZ44bwbSn/460egATzqKaEYtyh6mSVYqG9/cFGaQPJCx9r/fzT4tqp9q6RzuwGWbB5vDSel6EfSu9Pj7MjKpV2Rq+bS9dWjjX451yADg14hzZ9UZ1vNQkoRMLxafEhreABgLDkUiMzHJUl5gklfgCE/mgyRAYxf2QRO9XRdSWL6RHj0/6FHLFeuH2m8Qd47rH0opzt+rJnbVcQm4JGwU3Z1e5LJGnB7GpjL7pOftlkwuM8Hj+yI2m4uMR5/jEdLFqNWbU8v2ILu+mk59Lf9ioxetOUfK5CHIHJ9LliZAT6iq54m1O0Se04gRzITd9jT7Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orQC5QpgrOXr5SSPwXcz20llPIV/XCjUZG3+ZWvwI+M=;
 b=MKMR3LikfNq1LR1TVPDY3MsktmBBZLdznCmdysgD4G2uhh++AAEBa7gA1NfzY60rz4CBpSJ9W7de5W6e3ZVos9IWQ4ZGfilxGnd8/2PXmCzno8iUUOsjmzVq8XBV6BtBr/b7T5KnH+tFNA4fpMLMduFHFePfaIkoifF13S8auOM=
Received: from BN9PR03CA0553.namprd03.prod.outlook.com (2603:10b6:408:138::18)
 by LV5PR12MB9754.namprd12.prod.outlook.com (2603:10b6:408:305::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Mon, 29 Sep
 2025 08:52:26 +0000
Received: from BN2PEPF000055DB.namprd21.prod.outlook.com
 (2603:10b6:408:138:cafe::d1) by BN9PR03CA0553.outlook.office365.com
 (2603:10b6:408:138::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.13 via Frontend Transport; Mon,
 29 Sep 2025 08:52:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000055DB.mail.protection.outlook.com (10.167.245.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.0 via Frontend Transport; Mon, 29 Sep 2025 08:52:26 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 29 Sep
 2025 01:52:25 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 29 Sep
 2025 01:52:25 -0700
Received: from [10.252.207.152] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 29 Sep 2025 01:52:22 -0700
Content-Type: multipart/mixed;
	boundary="------------7CuE9kGtprnVonJtMuyAZHO2"
Message-ID: <2b2ebc13-e4cd-4a05-98bf-8ca3959fb138@amd.com>
Date: Mon, 29 Sep 2025 14:22:16 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] KVM: SVM: Add Page modification logging support
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250925101052.1868431-1-nikunj@amd.com>
 <20250925101052.1868431-6-nikunj@amd.com>
 <4321f668a69d02e93ad40db9304ef24b66a0f19d.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <4321f668a69d02e93ad40db9304ef24b66a0f19d.camel@intel.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DB:EE_|LV5PR12MB9754:EE_
X-MS-Office365-Filtering-Correlation-Id: b0334d4e-8ad2-4cc4-d554-08ddff358379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|4053099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWJuMTlRZzVYanpVSUJuMW56Q1IyNG1sdDlZLzVkVVdEdS9IbVFQcmk2WHdT?=
 =?utf-8?B?dmVzS2ZUcUZUY2FzRllleTM3TWw2N2lJV0tLOTMva1MwT3A4cGJGeWo5ZzY4?=
 =?utf-8?B?V0hKQmp6T1h1L2FhL1dXc055TW1SU253bG9KTzc2WjhiaU54NTJzdVhuZWJi?=
 =?utf-8?B?SEkweXkvM1pWOHNOWTIvZE1zVkxIV3VxMnNWN24vUkttV1VxYzFkcmI4UDV4?=
 =?utf-8?B?QmxYNGx6S0cyZytjbUpaQ0tNZkFsVnhxRFVkNmxZeHhpemhMY09XR3lzblgv?=
 =?utf-8?B?K3pWcjdKTGYvQjltVndsN3NjR3laYWt2eEk3UE1SNWFIc3pkUnovQVY5Wkh6?=
 =?utf-8?B?ckhodm0wNWNqYkM0eUh0MU5xQXVwRlgyc1JZYXdodzB1K3lSTU5yd0l1Vm5O?=
 =?utf-8?B?emozeDRjM1JzZFovQWZPaVVpdjU2RjBhYVp3ZzQ2cVU4WlN1bW1jNCtFTkNs?=
 =?utf-8?B?WDU3L2NVZmsxckhWVTBMSkswSDVzUkNvOFZiYURsTGFaT2dWTm56Q1B1b3Bj?=
 =?utf-8?B?YXBVa012YWtDdkFUdEFsUmRhMzNUcmhWamd3T2ROSWNWRFczT3NlNUppeWhB?=
 =?utf-8?B?QzVubGFNRDJBQlJ6YkN4eWFDaXUySk9yeStjQkxWb1BtdzBLbmp3ajYzUk1m?=
 =?utf-8?B?WDg5aVJmcC9ILzFIMjFEREthZGdrYjAycUpRMFgzTWordDVlK0ZRZDc0Vzlm?=
 =?utf-8?B?NExmNzBYSzI3Q3l1czJBdnU4TjJmOEFoVC93WHgwbTBXekFKRVNlNXFMS3kx?=
 =?utf-8?B?WVRiaGo5WXBsWEF2Q3o2azZsSTZkam1DcDZaSmVIRnNha09KcnB3SXpoM0t5?=
 =?utf-8?B?TGh0MVlxcS91ZWpGcVpUVGFzdG9oaGltWEduRFR3MmphOUplaC83ZW0reEp4?=
 =?utf-8?B?VUV6ZWU0VWRZeW5SNUE3WE81eWFTeEZtNzdLQmszMXRaTDcvbHFZWDRQYlZ0?=
 =?utf-8?B?OWxTalN5UXEyQk1UL2pCVWx0elRBR0prcGd4dDJ1blNZZUdzTFc5ZittczNj?=
 =?utf-8?B?LzhyRk5mdk00S01LZlpraWdqbDFFL2szK2JMeFRTaHFuL3NBUDhveFZBdVFE?=
 =?utf-8?B?cjVTRVJDUEJGWUNHSjZWMHNjcHE4dUpxOGxYblpJQVRNenJVbmdjRmhRNGpH?=
 =?utf-8?B?NXF1bVcyTFlJbExSL3FBelpidDN2VVNIS1M1d3VtaXRxMm1xODg0K0p0WFFx?=
 =?utf-8?B?WHFBM2E4WmM1bjJXeDBrTENITjM1d3NFYkFlYzNFTGcrMjN5UHlOWityUkYx?=
 =?utf-8?B?QzB1UTFTWlVqR2d6aENDR3pXRkVQK1dVc1RxdGV0NUdnV1dxdVBqQnpVSi9N?=
 =?utf-8?B?WldnWnBrQWdYa0tsU3J0LzRBMUpxMEZ4UGVqVFpMMElBYzloRURmOEwrZldC?=
 =?utf-8?B?QkdNM0dSOUFlcEYyUEVGRWd4Z3VxdDJheG1jR3cyY1JEY3lyY2lCeU1UY0E3?=
 =?utf-8?B?MG1uYWpZYmNvL2NRaE9KdzFGY2xsQ1E0MGlGOHRFbHY1Z2lLUWdYak5wbCtm?=
 =?utf-8?B?R2c3bzdmZTRCNW5EN296dnZ0T2c4ZmJjWjRlWThNYVVlakdmQnNpRGgyQUk0?=
 =?utf-8?B?WTh1bDF0b1VQQ2t3NGM2bERUYzUxV0tRTjZjWVJPQjBTUDc5UDlwYm5TL09m?=
 =?utf-8?B?dTd6dmd0bW5GVldxczdpQlNvT25xeE85eW9wVmo2QytLczRRZUw3bDhOSzNN?=
 =?utf-8?B?cFh4b1F5NXBTcUZweXl0d0l5ZWU4L1lMSjFINDBWa3NCU0E5Q2drejZOVzlK?=
 =?utf-8?B?ZllIZ1Y4dXNMYjRkYkhjOUtkLzNJRnk3MUlVbWJJbldZTEhiTmwvZ0tSSS94?=
 =?utf-8?B?eHVBbG9ZMytaWHdDZ1A1WmtIMjJxMmI3ZXlhc1Y3aWoyaUFFZ2QrMUxyM1RB?=
 =?utf-8?B?SjVzSVRpTFN0THJ2RjhjcHV3YW03Uy9nTnZYODlxVGVBZkVuaGxTY0Q3Nk9X?=
 =?utf-8?B?b1djQTFhSGRTRnpMQ3VCekMrL1pMdkRXUFdzTW9ueVhsUyt2TXl1L2RhN3Fz?=
 =?utf-8?B?QVhOaEVSc0lIVEREOTRobFRscWZ1K2JPZEF3REo1NEMwTGZxYjJZemJqUmZK?=
 =?utf-8?B?L0x6eGFPTnpJamR4Tml0TUdFQ3FQNmpndkxrU1YyK2JEREdqUVB2S1huRDRr?=
 =?utf-8?Q?THFg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(4053099003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 08:52:26.0206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0334d4e-8ad2-4cc4-d554-08ddff358379
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9754

--------------7CuE9kGtprnVonJtMuyAZHO2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On 9/29/2025 7:11 AM, Huang, Kai wrote:
> 
>> -	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
>> -	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
>> +	/*
>> +	 * Copied from vmcb01.  msrpm_base can be overwritten later.
>> +	 * Disable PML for nested guest.
>> +	 */
>> +	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl & ~SVM_NESTED_CTL_PML_ENABLE;
> 
> Nit: one side topic:
> 
> It's a bit surprising that currently vmcb01's nested_ctl is copied
> directly to vmcb02.  

At present, I see only SVM_NESTED_CTL_NP_ENABLE being set, other than PML.

> I thought the logic should be more like:
> 
> 	vmcb02->control.nested_ctl = VMCB02_NESTED_CTL_MINIMAL;
> 	if (nested_cpu_has(vmcb12, SOME_FEATURE))
> 		vmcb02->control.nested_ctl |=
> SVM_NESTED_CTL_SOME_FEATURE;
> 	...
> 
> But I guess we can enhance here later, when needed.
Agreed.

> 
>>  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
>>  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
>>  
>> @@ -1177,6 +1180,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>>  		svm_update_lbrv(vcpu);
>>  	}
>>  
>> +	/* Update dirty logging that might have changed while L2 ran */
>> +	if (svm->nested.update_vmcb01_cpu_dirty_logging) {
>> +		svm->nested.update_vmcb01_cpu_dirty_logging = false;
>> +		svm_update_cpu_dirty_logging(vcpu);
>> +	}
>> +
>>
> 
> [...]
> 
>>  
>> +void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +	if (WARN_ON_ONCE(!pml))
>> +		return;
>> +
>> +	if (is_guest_mode(vcpu)) {
>> +		svm->nested.update_vmcb01_cpu_dirty_logging = true;
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Note, nr_memslots_dirty_logging can be changed concurrently with this
>> +	 * code, but in that case another update request will be made and so the
>> +	 * guest will never run with a stale PML value.
>> +	 */
>> +	if (atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
>> +		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_PML_ENABLE;
>> +	else
>> +		svm->vmcb->control.nested_ctl &= ~SVM_NESTED_CTL_PML_ENABLE;
>> +}
>> +
>>
> 
> [...]
> 
>>  	if (lbrv) {
>>  		if (!boot_cpu_has(X86_FEATURE_LBRV))
>>  			lbrv = false;
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 70df7c6413cf..ce38f4a885d3 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -216,6 +216,9 @@ struct svm_nested_state {
>>  	 * on its side.
>>  	 */
>>  	bool force_msr_bitmap_recalc;
>> +
>> +	/* Indicates whether dirty logging changed while nested guest ran */
>> +	bool update_vmcb01_cpu_dirty_logging;
>>  };
>>  
>>  struct vcpu_sev_es_state {
>> @@ -717,6 +720,8 @@ static inline void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
>>  	svm_set_intercept_for_msr(vcpu, msr, type, true);
>>  }
>>  
>> +void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>> +
>>
> 
> There are duplicated code between SVM and VMX for the above chunks.  The
> logic of marking 'update_cpu_dirty_logging' as pending when vCPU is in L2
> mode and then actually updating the CPU dirty logging when existing from
> L2 to L1 can be made common, as both SVM and VMX share the same logic.

Yes, this can be consolidated as well.
 > How about below diff [*]? It could be split into multiple patches (e.g.,
> one to move the code around 'update_cpu_dirty_logging_pending' from VMX to
> x86 common, and the other one to apply SVM changes on top of that).
> 
> Build test only .. I plan to have a test as well (needing to setup testing
> environment) but it would be great to see whether it works at SVM side.
> > [*] The diff (also attached):

I tested the above patch and it needed few SVM and x86 changes, here is a
diff on top of your patch that works on SVM:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 009cef2477f0..d3030c99dba3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3232,10 +3232,12 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 
 void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	if (enable)
-		svm->vmcb->control.nested_ctl |= svm_nested_ctl_pml_enable;
+		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_PML_ENABLE;
 	else
-		svm->vmcb->control.nested_ctl &= ~svm_nested_ctl_pml_enable;
+		svm->vmcb->control.nested_ctl &= ~SVM_NESTED_CTL_PML_ENABLE;
 }
 
 static void svm_flush_pml_buffer(struct kvm_vcpu *vcpu)
@@ -3628,7 +3630,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * dirty bitmap current by processing logged GPAs rather than waiting for
 	 * PML_FULL exit.
 	 */
-	if (pml && !is_guest_mode(vcpu))
+	if (enable_pml && !is_guest_mode(vcpu))
 		svm_flush_pml_buffer(vcpu);
 
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
@@ -5097,7 +5099,7 @@ static int svm_vm_init(struct kvm *kvm)
 			return ret;
 	}
 
-	if (pml)
+	if (enable_pml)
 		kvm->arch.cpu_dirty_log_size = PML_LOG_NR_ENTRIES;
 
 	svm_srso_vm_init();
@@ -5457,7 +5459,7 @@ static __init int svm_hardware_setup(void)
 	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
 
 	enable_pml = enable_pml && npt_enabled && cpu_feature_enabled(X86_FEATURE_PML);
-	if (pml)
+	if (enable_pml)
 		pr_info("Page modification logging supported\n");
 
 	if (lbrv) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ce38f4a885d3..a73306592f18 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -51,6 +51,7 @@ extern bool intercept_smi;
 extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
+extern bool __read_mostly enable_pml;
 
 /*
  * Clean bits in VMCB.
@@ -216,9 +217,6 @@ struct svm_nested_state {
 	 * on its side.
 	 */
 	bool force_msr_bitmap_recalc;
-
-	/* Indicates whether dirty logging changed while nested guest ran */
-	bool update_vmcb01_cpu_dirty_logging;
 };
 
 struct vcpu_sev_es_state {
@@ -720,7 +718,7 @@ static inline void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	svm_set_intercept_for_msr(vcpu, msr, type, true);
 }
 
-void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
+void svm_update_cpu_dirty_logging(struct kvm_vcpu *vcpu, bool enable);
 
 /* nested.c */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95843c854b11..35a748b0d4af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -146,6 +146,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
+EXPORT_STATIC_CALL_GPL(kvm_x86_update_cpu_dirty_logging);
 
 static bool __read_mostly ignore_msrs = 0;
 module_param(ignore_msrs, bool, 0644);




--------------7CuE9kGtprnVonJtMuyAZHO2
Content-Type: text/plain; charset="UTF-8"; name="pml_x86_svm_fixes.diff"
Content-Disposition: attachment; filename="pml_x86_svm_fixes.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3Zt
L3N2bS5jCmluZGV4IDAwOWNlZjI0NzdmMC4uZDMwMzBjOTlkYmEzIDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni9rdm0vc3ZtL3N2bS5jCisrKyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMKQEAg
LTMyMzIsMTAgKzMyMzIsMTIgQEAgc3RhdGljIGludCBidXNfbG9ja19leGl0KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkKIAogdm9pZCBzdm1fdXBkYXRlX2NwdV9kaXJ0eV9sb2dnaW5nKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBlbmFibGUpCiB7CisJc3RydWN0IHZjcHVfc3Zt
ICpzdm0gPSB0b19zdm0odmNwdSk7CisKIAlpZiAoZW5hYmxlKQotCQlzdm0tPnZtY2ItPmNv
bnRyb2wubmVzdGVkX2N0bCB8PSBzdm1fbmVzdGVkX2N0bF9wbWxfZW5hYmxlOworCQlzdm0t
PnZtY2ItPmNvbnRyb2wubmVzdGVkX2N0bCB8PSBTVk1fTkVTVEVEX0NUTF9QTUxfRU5BQkxF
OwogCWVsc2UKLQkJc3ZtLT52bWNiLT5jb250cm9sLm5lc3RlZF9jdGwgJj0gfnN2bV9uZXN0
ZWRfY3RsX3BtbF9lbmFibGU7CisJCXN2bS0+dm1jYi0+Y29udHJvbC5uZXN0ZWRfY3RsICY9
IH5TVk1fTkVTVEVEX0NUTF9QTUxfRU5BQkxFOwogfQogCiBzdGF0aWMgdm9pZCBzdm1fZmx1
c2hfcG1sX2J1ZmZlcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCkBAIC0zNjI4LDcgKzM2MzAs
NyBAQCBzdGF0aWMgaW50IHN2bV9oYW5kbGVfZXhpdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
IGZhc3RwYXRoX3QgZXhpdF9mYXN0cGF0aCkKIAkgKiBkaXJ0eSBiaXRtYXAgY3VycmVudCBi
eSBwcm9jZXNzaW5nIGxvZ2dlZCBHUEFzIHJhdGhlciB0aGFuIHdhaXRpbmcgZm9yCiAJICog
UE1MX0ZVTEwgZXhpdC4KIAkgKi8KLQlpZiAocG1sICYmICFpc19ndWVzdF9tb2RlKHZjcHUp
KQorCWlmIChlbmFibGVfcG1sICYmICFpc19ndWVzdF9tb2RlKHZjcHUpKQogCQlzdm1fZmx1
c2hfcG1sX2J1ZmZlcih2Y3B1KTsKIAogCS8qIFNFVi1FUyBndWVzdHMgbXVzdCB1c2UgdGhl
IENSIHdyaXRlIHRyYXBzIHRvIHRyYWNrIENSIHJlZ2lzdGVycy4gKi8KQEAgLTUwOTcsNyAr
NTA5OSw3IEBAIHN0YXRpYyBpbnQgc3ZtX3ZtX2luaXQoc3RydWN0IGt2bSAqa3ZtKQogCQkJ
cmV0dXJuIHJldDsKIAl9CiAKLQlpZiAocG1sKQorCWlmIChlbmFibGVfcG1sKQogCQlrdm0t
PmFyY2guY3B1X2RpcnR5X2xvZ19zaXplID0gUE1MX0xPR19OUl9FTlRSSUVTOwogCiAJc3Zt
X3Nyc29fdm1faW5pdCgpOwpAQCAtNTQ1Nyw3ICs1NDU5LDcgQEAgc3RhdGljIF9faW5pdCBp
bnQgc3ZtX2hhcmR3YXJlX3NldHVwKHZvaWQpCiAJbnJpcHMgPSBucmlwcyAmJiBib290X2Nw
dV9oYXMoWDg2X0ZFQVRVUkVfTlJJUFMpOwogCiAJZW5hYmxlX3BtbCA9IGVuYWJsZV9wbWwg
JiYgbnB0X2VuYWJsZWQgJiYgY3B1X2ZlYXR1cmVfZW5hYmxlZChYODZfRkVBVFVSRV9QTUwp
OwotCWlmIChwbWwpCisJaWYgKGVuYWJsZV9wbWwpCiAJCXByX2luZm8oIlBhZ2UgbW9kaWZp
Y2F0aW9uIGxvZ2dpbmcgc3VwcG9ydGVkXG4iKTsKIAogCWlmIChsYnJ2KSB7CmRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5oIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uaApp
bmRleCBjZTM4ZjRhODg1ZDMuLmE3MzMwNjU5MmYxOCAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a3ZtL3N2bS9zdm0uaAorKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5oCkBAIC01MSw2ICs1
MSw3IEBAIGV4dGVybiBib29sIGludGVyY2VwdF9zbWk7CiBleHRlcm4gYm9vbCB4MmF2aWNf
ZW5hYmxlZDsKIGV4dGVybiBib29sIHZubWk7CiBleHRlcm4gaW50IGxicnY7CitleHRlcm4g
Ym9vbCBfX3JlYWRfbW9zdGx5IGVuYWJsZV9wbWw7CiAKIC8qCiAgKiBDbGVhbiBiaXRzIGlu
IFZNQ0IuCkBAIC0yMTYsOSArMjE3LDYgQEAgc3RydWN0IHN2bV9uZXN0ZWRfc3RhdGUgewog
CSAqIG9uIGl0cyBzaWRlLgogCSAqLwogCWJvb2wgZm9yY2VfbXNyX2JpdG1hcF9yZWNhbGM7
Ci0KLQkvKiBJbmRpY2F0ZXMgd2hldGhlciBkaXJ0eSBsb2dnaW5nIGNoYW5nZWQgd2hpbGUg
bmVzdGVkIGd1ZXN0IHJhbiAqLwotCWJvb2wgdXBkYXRlX3ZtY2IwMV9jcHVfZGlydHlfbG9n
Z2luZzsKIH07CiAKIHN0cnVjdCB2Y3B1X3Nldl9lc19zdGF0ZSB7CkBAIC03MjAsNyArNzE4
LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHN2bV9lbmFibGVfaW50ZXJjZXB0X2Zvcl9tc3Io
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LAogCXN2bV9zZXRfaW50ZXJjZXB0X2Zvcl9tc3IodmNw
dSwgbXNyLCB0eXBlLCB0cnVlKTsKIH0KIAotdm9pZCBzdm1fdXBkYXRlX2NwdV9kaXJ0eV9s
b2dnaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cit2b2lkIHN2bV91cGRhdGVfY3B1X2Rp
cnR5X2xvZ2dpbmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29sIGVuYWJsZSk7CiAKIC8q
IG5lc3RlZC5jICovCiAKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gv
eDg2L2t2bS94ODYuYwppbmRleCA5NTg0M2M4NTRiMTEuLjM1YTc0OGIwZDRhZiAxMDA2NDQK
LS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jCisrKyBiL2FyY2gveDg2L2t2bS94ODYuYwpAQCAt
MTQ2LDYgKzE0Niw3IEBAIHN0cnVjdCBrdm1feDg2X29wcyBrdm1feDg2X29wcyBfX3JlYWRf
bW9zdGx5OwogI2luY2x1ZGUgPGFzbS9rdm0teDg2LW9wcy5oPgogRVhQT1JUX1NUQVRJQ19D
QUxMX0dQTChrdm1feDg2X2dldF9jc19kYl9sX2JpdHMpOwogRVhQT1JUX1NUQVRJQ19DQUxM
X0dQTChrdm1feDg2X2NhY2hlX3JlZyk7CitFWFBPUlRfU1RBVElDX0NBTExfR1BMKGt2bV94
ODZfdXBkYXRlX2NwdV9kaXJ0eV9sb2dnaW5nKTsKIAogc3RhdGljIGJvb2wgX19yZWFkX21v
c3RseSBpZ25vcmVfbXNycyA9IDA7CiBtb2R1bGVfcGFyYW0oaWdub3JlX21zcnMsIGJvb2ws
IDA2NDQpOwo=

--------------7CuE9kGtprnVonJtMuyAZHO2--

