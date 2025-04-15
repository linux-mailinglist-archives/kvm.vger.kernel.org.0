Return-Path: <kvm+bounces-43342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86431A89B95
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 13:12:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0D6E189E6E5
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8288A28F53F;
	Tue, 15 Apr 2025 11:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eIsJEZRL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D631A28E5F4;
	Tue, 15 Apr 2025 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744715509; cv=fail; b=LW8dKy52en4Q+EbqSP+dGGyBRV/yLwisEbbDTVKwcBEiJ7TNuPwIZuM9ygt3sA6JrOPpeU436NrTMXzJtNGJIGMc3svn8G4ZLhcKQUB+5Stx1PsIUTI6DaaqSoSODPkpglMZ4injHlMcdBF2z1GFi681CCy7eD5pPREHxegDz+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744715509; c=relaxed/simple;
	bh=n1J4KJCrnJEIyuxQn5f6iiK0t+wgI0wClmTWkJgExag=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NNMu3hdGsPn14d2STUB5acIX37DorApCmlyJLQ82QtdfXdsIz7F0nO8UHmXbdDMFMIaHkLJDTV8D5F1uNxSJq3qbx+00af9vinf3KpxKvnaUwUxqC64sycd0UPCxQWP6pXJCkfDUWZJ+5QVmxUkc5vPlGV8NPilLR68SvBT6cqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eIsJEZRL; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPYHXsAWCA/D3ERsPGKohTO5TSJUDHME3PUtaLf2jTnWKfE8XU6fKf7zydz7uvCpwIz0a4u4bqfJDLtozzQs/mHW8FR8hkUJzvtMlSIPhrQhJAAe5U0Xz1VN87PO+Y/f87I807Vvy9GUjRXxeHwcLS1r7oT/pfuS8XW2eBXzCfYxBPBWIolPd9Wyr9qpzpMc4BYUJ3VHvRYZQ69CAKbnkdnzyx5ohBdvSqem9O6kxtjO9jylobVm97zY/Zn1uOoxIMnbjg+x9XDcwmYIANGXBSY93fevJwBLRvjq4kIPylxbi0TSCqczu0pkBr8UkhgclpNElgbk+C01REsNcDNUOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ba6UAPxpK1JO9VzLJfGJ8K/FN5kC6EdXtEGTEd/GIUM=;
 b=XktJV9VLq1X8J7aIAkD08x6hNy2jBP4cxX4qVj04YJJj5s3ga0PJ/v5hYi6+pgXHhvexQ6hRM/jjzMlERpmzxjsEYZMUsWW+LioV44AX4Cax3GPFY8hgpxVnrsiAktDrLC80Y58Vjw66HOllNILreJlgJ9DJthIzTTXaP1D0byMcTLP0eiIuZhNJ0mkSOnDgIzoQdLNJ1nyqctym2Ha1hpOdyUP7HEyczG6CGfJNmVeabDAFh1zpDuvrd7+9pt6EU2v946z2TgHzkpT8+uVBAKioEEuEpobWWUvOxJMkr7vuAk83wUkzOJoVgcHX5ouYGbw5H3zQm1NXtEY4E7DXlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ba6UAPxpK1JO9VzLJfGJ8K/FN5kC6EdXtEGTEd/GIUM=;
 b=eIsJEZRLAmwF+SgVwnoujuFPzyeN3vFe+RK6AkA/gsyWzNTPZNNmuU2EmOmaQf1GPgIzopWQuHaC49aypM44KZ3x9uRZDrnsdeRxtzPfe4fX85ScfqC/D8hNdjjvQBlyPUiNx0nHAt3Ityd7t1CsxrTn3dCwVpuaO05azDfQQpw=
Received: from PH0PR07CA0081.namprd07.prod.outlook.com (2603:10b6:510:f::26)
 by PH7PR12MB7137.namprd12.prod.outlook.com (2603:10b6:510:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.30; Tue, 15 Apr
 2025 11:11:41 +0000
Received: from CY4PEPF0000E9D3.namprd03.prod.outlook.com
 (2603:10b6:510:f:cafe::3b) by PH0PR07CA0081.outlook.office365.com
 (2603:10b6:510:f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.33 via Frontend Transport; Tue,
 15 Apr 2025 11:11:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D3.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Tue, 15 Apr 2025 11:11:41 +0000
Received: from [10.85.32.54] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Apr
 2025 06:11:37 -0500
Message-ID: <2cc31ce5-0f1a-41d6-a169-491f9712ffdc@amd.com>
Date: Tue, 15 Apr 2025 16:41:35 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/67] KVM: SVM: Add helper to deduplicate code for
 getting AVIC backing page
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Joao
 Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-15-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-15-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D3:EE_|PH7PR12MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: 932ef7bf-80b0-4114-4d3d-08dd7c0e4cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnVKdHFkNi8rZjZCUTVSeVVLaDQxdTNCNmE2L2tBcFZveHJmOWJWR1RKUWI2?=
 =?utf-8?B?cG9rZUZpckJZck9TU0pweUUxYWt5N3lwZXA0NVdUVHFUZjZkNUdvcytEYUg2?=
 =?utf-8?B?UmR5MXFRbUlqa0VKSGVRcEVzVTF0dnVkOU1qVDVTY1pTZzVWazlWVEdJZFpI?=
 =?utf-8?B?blNWbHV6SEdiaHF2Q29LRFZqQUpmNi9TWnBSdXRJUnZnRC9vMU5tTW55dnE2?=
 =?utf-8?B?SElmYnRReXVsUW1RZFpNQ2Zwd01rS1MxSGJtaXkybGU3MW9Hcm9vQU4rYVNN?=
 =?utf-8?B?L2Uzd3lYL1RKcFJnbS9vZVIybWVNM09wQXNvZk5Xd0FHTmx3SUFPZjZPcmNN?=
 =?utf-8?B?K1NhanovSWhuVGU4UUdIRTZaK01qZzRJQ2lFL1hUOGxNVStjejFacXFBQUUr?=
 =?utf-8?B?VENZOHNPWGRPajdiS25KUzcxVHNoVE1UQmRqazJJdzFLZGJmcUxUbWVGUDFD?=
 =?utf-8?B?R1FzZ0RkS3pwak42TWEvQ0dXa0pTNUhsVGRFOVBxNkNGdmxxaFF6TC9oSFdi?=
 =?utf-8?B?a0ZNNHZZZVR1NlI1RGdMQk1BNk80TEhXM002aFJqeUo4SldXTkdYR005WjVD?=
 =?utf-8?B?d0lBNXdyWGRRLzcwTlcxTnJKRFBqNzRUM3MvNzhMRmVQR3FUWjZiV0RHQWpi?=
 =?utf-8?B?alBOdDBPWGVxN2dxeHBRZFBkNDQvTHlNZVlZWnRYTUJoSFFCZnRLZ2F0WFp2?=
 =?utf-8?B?RDdXd2ZleTYzbXBVdzZMYzRhTzR1bzN2Sng4bmpPTlhmSEwySVIxTlZtM2hs?=
 =?utf-8?B?VG1IeUJsV29mOXZqdkVidnlKOGdHV3EvdkhabEdHVmFWVHFQRjQrVE9TUVJL?=
 =?utf-8?B?MHdIMFRpRjFaT1VGOWpSN2N5VFVXSHh4VHN2VmtZbGtuRTQ1ZEtEV0xNTlYy?=
 =?utf-8?B?OUZkeUk4cHhzR1lneXBYL0ZUblBZTVQvMjI5WW5jS0ZqS2ZUMFlDaGtsTnpn?=
 =?utf-8?B?NU9HVHc1OXVhdzNIbHdER3JQelFOdVNQbURGeUlDTzE5OUhnZjNiMUd1aW0y?=
 =?utf-8?B?eUdVTVA4Q2lZanBNYjkvZWVCb1VEUGdLRng4MlM0V3FoZWhMRDFheUhmeU5p?=
 =?utf-8?B?N0lXdU01cTF6dE9HMUxCclpMU0tRM0xIUldtSEJCUG5YdloyZXlvMTMrUmQz?=
 =?utf-8?B?T3k1MEMrU0FOUGpma0FpRnFuZjlwS3pxcnJSUmJBNWJxRUZHVFJ6ZmhRMWdE?=
 =?utf-8?B?QXNqOVB1NGJnWC85MFkvL0c2ckJFalYvVjZsV2Zua3BTeTNqTmF3R3oxTHJJ?=
 =?utf-8?B?SHQ4NGkvVGZrMzZKaFBIV0NLYVl6RFFWNC81UXErRHlVb05yS2k3SFoxejBq?=
 =?utf-8?B?SWFEZHA3M09kR2ZscHR6WEFkc2NyQ29adFcrVlZ3N21tb1ZYSm81SGJBbEZH?=
 =?utf-8?B?bFArN3AzVHcwN3BNYktDZFRwMEJiTk1obW1lY1NUSE1OMEs2bllvUEpTc2RM?=
 =?utf-8?B?bGZabnRnVENkVDY2MkNTQ1VvaURUTlFzbVlzVlc5eTJScy94RDJIeHp1QVo4?=
 =?utf-8?B?ME0wQWZ6WWRMYXB0U3ZoTCswcVNSbE4wQitoeHNZRGhVZTMzUGZEVnkxL2N1?=
 =?utf-8?B?aDFXRWthcjNTNlNxZndoUTFPK290OFRrY2hyVGhEQmo1emh0WlFIem1SWDVw?=
 =?utf-8?B?aHM4VnYvTmRacklqVDBJeUNrcFo0YVNGcm9DbElmOC80bHJEdDhINWJWeXpa?=
 =?utf-8?B?OVZDZEZUTnVCMHY1UFYrbURxMFRHZE4zVXRuMzYvOEVpQnR1RFo1ZDFReWh3?=
 =?utf-8?B?VmpLcTZwLzNQbEFiT3hEZURkNEJrZENpNjlCc3ZKWGQ5S1E5cjFBYmw3Smxx?=
 =?utf-8?B?YnBXTnljQjQreUdFV3g1TXEzZWE4ejlrQTRVNkh2ZUJPRU51Mk5nbXpPYnJE?=
 =?utf-8?B?Q1RqS0FHNXRPWHpNZXRaVUxWM3R6dmhJQ1pWTWsra2pOSXdHQXJUcTQ3V242?=
 =?utf-8?B?VU14bjBySkowMTlxblk1QVpIcXN0dGErS25zZ0RsSFByTWxUM05UMlFUQ3Vo?=
 =?utf-8?B?V1RicWoxRDhvYmI4SVA1MmxhZUZMQXFTU3BObG1iZUk2N3FlNXJ4UmZURi9J?=
 =?utf-8?Q?+F3cLB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 11:11:41.3383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 932ef7bf-80b0-4114-4d3d-08dd7c0e4cb7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7137

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
Hi Sean,

> Add a helper to get the physical address of the AVIC backing page, both
> to deduplicate code and to prepare for getting the address directly from
> apic->regs, at which point it won't be all that obvious that the address
> in question is what SVM calls the AVIC backing page.
> 
> No functional change intended.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index f04010f66595..a1f4a08d35f5 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -243,14 +243,18 @@ int avic_vm_init(struct kvm *kvm)
>   	return err;
>   }
>   
> +static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
> +{
> +	return __sme_set(page_to_phys(svm->avic_backing_page));
> +}
> +

Maybe why not introduce a generic function like...

static phsys_addr_t page_to_phys_sme_set(struct page *page)
{
	return __sme_set(page_to_phys(page));
}

and use it for avic_logical_id_table_page and
avic_physical_id_table_page as well.
		
Regards
Sairaj
>   void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>   {
>   	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
> -	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
>   	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
>   	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
>   
> -	vmcb->control.avic_backing_page = bpa;
> +	vmcb->control.avic_backing_page = avic_get_backing_page_address(svm);
>   	vmcb->control.avic_logical_id = lpa;
>   	vmcb->control.avic_physical_id = ppa;
>   	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
> @@ -314,7 +318,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>   	BUILD_BUG_ON(__PHYSICAL_MASK_SHIFT >
>   		     fls64(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK));
>   
> -	new_entry = __sme_set(page_to_phys(svm->avic_backing_page)) |
> +	new_entry = avic_get_backing_page_address(svm) |
>   		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
>   	WRITE_ONCE(*entry, new_entry);
>   
> @@ -854,7 +858,7 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
>   	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
>   		 irq.vector);
>   	*svm = to_svm(vcpu);
> -	vcpu_info->pi_desc_addr = __sme_set(page_to_phys((*svm)->avic_backing_page));
> +	vcpu_info->pi_desc_addr = avic_get_backing_page_address(*svm);
>   	vcpu_info->vector = irq.vector;
>   
>   	return 0;
> @@ -915,7 +919,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   			enable_remapped_mode = false;
>   
>   			/* Try to enable guest_mode in IRTE */
> -			pi.base = __sme_set(page_to_phys(svm->avic_backing_page));
> +			pi.base = avic_get_backing_page_address(svm);
>   			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
>   						     svm->vcpu.vcpu_id);
>   			pi.is_guest_mode = true;


