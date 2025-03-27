Return-Path: <kvm+bounces-42111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8280A72E49
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 11:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 961C53B9D52
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 10:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DFA20FA8F;
	Thu, 27 Mar 2025 10:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1nlOXlR4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0064B20E310;
	Thu, 27 Mar 2025 10:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743073129; cv=fail; b=c02qU/bkBGccSAIWuGpVQgfalSzAeOIOpuNzcuRu3AtrZ+E9gFW8TXQ8xfL73YawHDQ/xINwMZhORLlW8pFFZ3h019o3xj41P+1fdTCrtEsL3uxp2r3QSh5Dy15UxsmH9ub9sio6g3rqFAaFwwz0gEGV9ed0DOArH9Y2I6wpYYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743073129; c=relaxed/simple;
	bh=jSScF3MCqUtc8AMQ/8QPBD0jbFLNU7BZhLPRm2mtrnU=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iiDaYHapMOsaXf95w1SEmcupyU/ROZ71i7W79178BwX/mHZxr349rbVvWjbdVSlxVWlzjaOHPa2Jb0wsVaplKacsqWNPKwRJP+vRVXjpHvjU3sSZDT3pGnXXRKJbOWg8HNxyJbBQJEvWi5w9Wzwxz8hCOTvhW6TCexuwMMp+fzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1nlOXlR4; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=asFyV4llKVzTRV93eiCuXtros2u494axt1BqZ3pQJ0fbtQenKs+fwH8SSGbDL0yOMMfVIqYI+ooDOpl4/CgrZqN50wrNMEmaBe0iarN07Nf/SJsgeHV3QUIOksD/OzHVtxWCoC/tv71J/DMItsjbFO4zQqN4g9bTiHCGDHOYXUrJg8E6D6F8ImwOTIGDJj9NHQaQzgUklYj8K9/ModfeCqE5wW2ORpRy+q8ufoDvFu2xRAJoxvoYt2aIpuKLn49V51y+b0g7fBpTxRhi2HdPeAr59bdi/TJ9ia/Y20CkgvAnl5aLrLqtFt4wgwIWo8eA947TWux4H6Nje/3zaHPZdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQjE289EKKDUQ8FFdvygtuSXduFoOxzO1Gwnzq0TD1o=;
 b=g+t5Uo/qD7vOCYBN5njEJtlf8yYZwYsAFHR2jcBLVsqaALLYPpXLiUeWM63TzdwvwSesUhrzUfDaiWsAvBFk1m1DvXt4GpKXrNFC/Wt+cSKTeu49ttvHqn3asLi2Yu5AFqPSvMAqJG6bJHsYNpESM0iFZfB4LYBXXOg8SOJucuWZS7WfI+oVgvkR+gWLESiqxUf0ndm4Db1Wzz4ycNx+cEe1gILCih2KSt/go2VQAuhl0Hk6fx505e2szwqCWPr6DOLYdWisCD9XZxgjalVomemb9dRH4mAPTWNTwozonZ/uCHt8BGnSb3lB7qrXGwudKjvKtxcasBn7eBGsOaSH6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQjE289EKKDUQ8FFdvygtuSXduFoOxzO1Gwnzq0TD1o=;
 b=1nlOXlR4wmcuAXHeIKoHnb1bI4xuR4QGYqLxw/GAnQ1/ISDDRmF36AXpgB6t8QJZRECI+mMKFNFnwrouKDM6XjxPhCX3+zEyKqr4LzC/Ft2wlPL6Wi+he2hV7fNd/FIlqL0/JzE+B+3rjuhNzK0906KMznp8AyfAauHY3354ie4=
Received: from DM5PR07CA0069.namprd07.prod.outlook.com (2603:10b6:4:ad::34) by
 MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 10:58:43 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:4:ad:cafe::26) by DM5PR07CA0069.outlook.office365.com
 (2603:10b6:4:ad::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.43 via Frontend Transport; Thu,
 27 Mar 2025 10:58:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 27 Mar 2025 10:58:43 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 27 Mar
 2025 05:58:38 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
	<seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Manali Shukla <manali.shukla@amd.com>,
	<santosh.shukla@amd.com>
Subject: Re: [RFC PATCH 01/24] KVM: VMX: Generalize VPID allocation to be
 vendor-neutral
In-Reply-To: <20250326193619.3714986-2-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-2-yosry.ahmed@linux.dev>
Date: Thu, 27 Mar 2025 10:58:31 +0000
Message-ID: <855xjun3jc.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|MN2PR12MB4192:EE_
X-MS-Office365-Filtering-Correlation-Id: 450f55eb-1f7e-48f2-cc18-08dd6d1e56f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D2/uI+cJy6Gmnhvwmi+7NzQvmQqj9kGsz8mc8nozFBhHZyr9JnTa53QFCmgV?=
 =?us-ascii?Q?xqdt7fn6u4DPGQpVbRrgz0wMgTBxAiNP7hJC3QlTkdoQKzPWchyIEdeFYPFo?=
 =?us-ascii?Q?T/378vjw7n6fhcUKFJShvjnd5r+OG7AEQXTKJJbItCCazaT7OFyDx66bRet5?=
 =?us-ascii?Q?Oui9V5cI4KUIUvrKD0Ys36VKEf8Qv9ybzRSylsosCN8sYuRQc18RSuh1k+Rl?=
 =?us-ascii?Q?316axOYyfoJHCVxstmnbjSloXZX4WbZqiUmSuRnBZRns9g4EGOSgH9kKCNv7?=
 =?us-ascii?Q?KWA2ryFvC/DQ/TNyrDh2TBtWJl4nzgJ4D8fIbiQfn8foPdlrErTB6O+E/WJG?=
 =?us-ascii?Q?30N8w7ek6yBXYUjsa7ZgnC3KaiPKcP03hNnztK+/9Mb/Uv7P6BLdo7qkI8e4?=
 =?us-ascii?Q?vql+Hba15VzDlr4bF1gh+OX6XgCEUJVKb9UQJPQCDJgEeFtilZVW0tgVxSC1?=
 =?us-ascii?Q?W5+H5XZz6iyiB8xtKRMhO8KMv8EfpPOsPYt43fCgQcbvfh+syGoON3asGmNn?=
 =?us-ascii?Q?1saPbTl4KAZtA023amhSbJsctjZ58i2OWG+ksLn3q0mNWqpGD3AZuAy6kJxu?=
 =?us-ascii?Q?JCepSZ+6lZZZ5rLYFJAOZCC2/YV5ktkdjHiq47wqDDvAJ/A+HWk0bhtldDNL?=
 =?us-ascii?Q?SXnHZBMxkC2lT3sNC+mJYNnD60JS6N4Ykmf38UETlraA+Ea0O7rkLmDedWPA?=
 =?us-ascii?Q?SMj78sspsGbjIPF5g0PGOw9kdjyfOsixH3lp/NeiRD14LssFR0jzyr3+UBaF?=
 =?us-ascii?Q?TUeqn7kt8eHSDUTug7tRbVtCKEXH7g5kurdCSayOdhNj3YTYACb+IIkyWsFr?=
 =?us-ascii?Q?OkYvkEBznhaiDTyIjMegPrNQ1cC6ykECtEoypUGtitbKyIf0j69RjdXTzADg?=
 =?us-ascii?Q?qHdcg+2aJTubWqLAztqHZuTVMJCx75KUAKzG0nNKwmMcPZtsvOnu4oDzsEaC?=
 =?us-ascii?Q?7xCKECEtCe9IY/bJB5WNqbnVPGpW1EfcL7DwMV9xGzwIvtHIa26caT7swjTl?=
 =?us-ascii?Q?CzgLQ9k9zdEThg2F581RzEDtPKpvGn6MdwB1uisTPX1WXx3/RMO8QL3kG520?=
 =?us-ascii?Q?t4mr0GIUQbz+wyWgqJ/2MgKyoa5gqhspBu/P0fLiDPrplQfcSApsyNzNCehm?=
 =?us-ascii?Q?F8zyiNruHJAf/AC4l+4oQbU52o4B3lejB7SfQ70+8hVKFFzh3/9AnIQxuwYf?=
 =?us-ascii?Q?FFQKhVWI+OW4n4HO99Aii0IYIiaRIH7h2+wOCxdLkT3r8zgfeDESkeWWhm9b?=
 =?us-ascii?Q?+hy8egaFZL51Ro9fs6AtCAij+4434dRpFKVwohYesZkZl2kiQ7+uMV5ljECP?=
 =?us-ascii?Q?PA7zFNjudO8F+dRQPKm8beampn8a8iz3BpXCA1OV4Z7R0E2NkcH9xQbJWE2U?=
 =?us-ascii?Q?4OI1SMjCMbRNyBAmoKpaM3Cfc2lLxohbW+v5YUHpIcG0vGGSH3WXBdbYgExk?=
 =?us-ascii?Q?BIJrfL/tJHpRl1pBuZAgq/+Vsq0K44Z+akk3DfPq2ReKumIHANulJVNhkUX1?=
 =?us-ascii?Q?S86ZHKv/cxKJ7xA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 10:58:43.0765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 450f55eb-1f7e-48f2-cc18-08dd6d1e56f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4192

Yosry Ahmed <yosry.ahmed@linux.dev> writes:

> Generalize the VMX VPID allocation code and make move it to common
> code

s/make//

> in preparation for sharing with SVM. Create a generic struct
> kvm_tlb_tags, representing a factory for VPIDs (or ASIDs later), and use
> one for VPIDs.
>
> Most of the functionality remains the same, with the following
> differences:
> - The enable_vpid checks are moved to the callers for allocate_vpid()
>   and free_vpid(), as they are specific to VMX.
> - The bitmap allocation is now dynamic (which will be required for SVM),
>   so it is initialized and cleaned up in vmx_hardware_{setup/unsetup}().
> - The range of valid TLB tags is expressed in terms of min/max instead
>   of the number of tags to support SVM use cases.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/vmx/nested.c |  4 +--
>  arch/x86/kvm/vmx/vmx.c    | 38 +++++--------------------
>  arch/x86/kvm/vmx/vmx.h    |  4 +--
>  arch/x86/kvm/x86.c        | 58 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h        | 13 +++++++++
>  5 files changed, 82 insertions(+), 35 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d06e50d9c0e79..b017bd2eb2382 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -343,7 +343,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  	vmx->nested.vmxon = false;
>  	vmx->nested.smm.vmxon = false;
>  	vmx->nested.vmxon_ptr = INVALID_GPA;
> -	free_vpid(vmx->nested.vpid02);
> +	kvm_tlb_tags_free(&vmx_vpids, vmx->nested.vpid02);
>  	vmx->nested.posted_intr_nv = -1;
>  	vmx->nested.current_vmptr = INVALID_GPA;
>  	if (enable_shadow_vmcs) {
> @@ -5333,7 +5333,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
>  		     HRTIMER_MODE_ABS_PINNED);
>  	vmx->nested.preemption_timer.function = vmx_preemption_timer_fn;
>  
> -	vmx->nested.vpid02 = allocate_vpid();
> +	vmx->nested.vpid02 = enable_vpid ? kvm_tlb_tags_alloc(&vmx_vpids) : 0;
>  
>  	vmx->nested.vmcs02_initialized = false;
>  	vmx->nested.vmxon = true;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b70ed72c1783d..f7ce75842fa26 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -496,8 +496,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
>   */
>  static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
>  
> -static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
> -static DEFINE_SPINLOCK(vmx_vpid_lock);
> +struct kvm_tlb_tags vmx_vpids;
>  
>  struct vmcs_config vmcs_config __ro_after_init;
>  struct vmx_capability vmx_capability __ro_after_init;
> @@ -3972,31 +3971,6 @@ static void seg_setup(int seg)
>  	vmcs_write32(sf->ar_bytes, ar);
>  }
>  
> -int allocate_vpid(void)
> -{
> -	int vpid;
> -
> -	if (!enable_vpid)
> -		return 0;
> -	spin_lock(&vmx_vpid_lock);
> -	vpid = find_first_zero_bit(vmx_vpid_bitmap, VMX_NR_VPIDS);
> -	if (vpid < VMX_NR_VPIDS)
> -		__set_bit(vpid, vmx_vpid_bitmap);
> -	else
> -		vpid = 0;
> -	spin_unlock(&vmx_vpid_lock);
> -	return vpid;
> -}
> -
> -void free_vpid(int vpid)
> -{
> -	if (!enable_vpid || vpid == 0)
> -		return;
> -	spin_lock(&vmx_vpid_lock);
> -	__clear_bit(vpid, vmx_vpid_bitmap);
> -	spin_unlock(&vmx_vpid_lock);
> -}
> -
>  static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>  {
>  	/*
> @@ -7559,7 +7533,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
>  
>  	if (enable_pml)
>  		vmx_destroy_pml_buffer(vmx);
> -	free_vpid(vmx->vpid);
> +	kvm_tlb_tags_free(&vmx_vpids, vmx->vpid);
>  	nested_vmx_free_vcpu(vcpu);
>  	free_loaded_vmcs(vmx->loaded_vmcs);
>  	free_page((unsigned long)vmx->ve_info);
> @@ -7578,7 +7552,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	err = -ENOMEM;
>  
> -	vmx->vpid = allocate_vpid();
> +	vmx->vpid = enable_vpid ? kvm_tlb_tags_alloc(&vmx_vpids) : 0;
>  
>  	/*
>  	 * If PML is turned on, failure on enabling PML just results in failure
> @@ -7681,7 +7655,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  free_pml:
>  	vmx_destroy_pml_buffer(vmx);
>  free_vpid:
> -	free_vpid(vmx->vpid);
> +	kvm_tlb_tags_free(&vmx_vpids, vmx->vpid);
>  	return err;
>  }
>  
> @@ -8373,6 +8347,7 @@ void vmx_hardware_unsetup(void)
>  		nested_vmx_hardware_unsetup();
>  
>  	free_kvm_area();
> +	kvm_tlb_tags_destroy(&vmx_vpids);
>  }
>  
>  void vmx_vm_destroy(struct kvm *kvm)
> @@ -8591,7 +8566,8 @@ __init int vmx_hardware_setup(void)
>  	kvm_caps.has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
>  	kvm_caps.has_notify_vmexit = cpu_has_notify_vmexit();
>  
> -	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
> +	/* VPID 0 is reserved for host, so min=1  */
> +	kvm_tlb_tags_init(&vmx_vpids, 1, VMX_NR_VPIDS - 1);

This needs to handle errors from kvm_tlb_tags_init().

>  
>  	if (enable_ept)
>  		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 951e44dc9d0ea..9bece3ea63eaa 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -376,10 +376,10 @@ struct kvm_vmx {
>  	u64 *pid_table;
>  };
>  
> +extern struct kvm_tlb_tags vmx_vpids;
> +
>  void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>  			struct loaded_vmcs *buddy);
> -int allocate_vpid(void);
> -void free_vpid(int vpid);
>  void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
>  void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>  void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 69c20a68a3f01..182f18ebc62f3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13992,6 +13992,64 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  
> +int kvm_tlb_tags_init(struct kvm_tlb_tags *tlb_tags, unsigned int min,
> +		      unsigned int max)
> +{
> +	/*
> +	 * 0 is assumed to be the host's TLB tag and is returned on failed
> +	 * allocations.
> +	 */
> +	if (WARN_ON_ONCE(min == 0))
> +		return -1;

Probably -EINVAL ?

> +
> +	/*
> +	 * Allocate enough bits to index the bitmap directly by the tag,
> +	 * potentially wasting a bit of memory.
> +	 */
> +	tlb_tags->bitmap = bitmap_zalloc(max + 1, GFP_KERNEL);
> +	if (!tlb_tags->bitmap)
> +		return -1;

-ENOMEM ?

> +
> +	tlb_tags->min = min;
> +	tlb_tags->max = max;
> +	spin_lock_init(&tlb_tags->lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_tlb_tags_init);
> +
> +void kvm_tlb_tags_destroy(struct kvm_tlb_tags *tlb_tags)
> +{
> +	bitmap_free(tlb_tags->bitmap);

Do we need to take tlb_tabs->lock here ?

> +}
> +EXPORT_SYMBOL_GPL(kvm_tlb_tags_destroy);
> +
> +unsigned int kvm_tlb_tags_alloc(struct kvm_tlb_tags *tlb_tags)
> +{
> +	unsigned int tag;
> +
> +	spin_lock(&tlb_tags->lock);
> +	tag = find_next_zero_bit(tlb_tags->bitmap, tlb_tags->max + 1,
> +				 tlb_tags->min);
> +	if (tag <= tlb_tags->max)
> +		__set_bit(tag, tlb_tags->bitmap);
> +	else
> +		tag = 0;

In the event that the KVM runs out of tags, adding WARN_ON_ONCE() here will
help debugging.

Regards
Nikunj


