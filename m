Return-Path: <kvm+bounces-45174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E600AA64E6
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 22:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF357987D57
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FB125335A;
	Thu,  1 May 2025 20:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X5OYT4P4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6933B7083A;
	Thu,  1 May 2025 20:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746132474; cv=fail; b=TUD6oBTPIlzkfJp8g0znfAvJlxpS0HE1Onz+BDQ6IdLf0Kj/pDLhReMb7qfX0SCzHIJtA5twAADWOWtEmJkD8xbWzbN3i+xCT4fKs4KQf+PbK9KT+Mc+znhJhmusSa881Ko4AGfgKz8ZPH6ai4+p/Eh5scel9/SinVHy3TtWtDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746132474; c=relaxed/simple;
	bh=hnRGngrUoAgETx2I1JLbWSyiBv0Y2c/BfUfEi5ori/E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jl/5yL/dPIWlvBhqCEPC0YMwVA2km4+/pg4s+913qYHzlTqgxC+1ryg6hlvvr4PsfE5snjfDOJw1j8lis7E+CwNmzNAtiZjwL51eduXI9vZnPDC+ZX3iSRO5HzrJgvgRQj0SJw07A5eVODsCxH+VhJ2yi75j/YmBGjoad+oGGzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X5OYT4P4; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SFqVgFer2RRCB4SOihR1CmDyGvINnew9G+X/YhkXuZWhwya3/zEg9dMKw+MHyBGxHCyYOAt48b8RRg01aQ2COVBASF2VcAlrMr2NH8DPmvhTF9P7mrdjdpvIbiFUHfSsZikGxtm/tULUj3OdHmnBhqmfINfSsXA2uDlS4AKeg9d/4yjgu5EXxpBAZWwhWGXMeBkJem6dFD9Tzgg0qpIrg/6CeTNsC2V553IuHCGt02nn+vyqeVWir8XtvY23dduZyyDuZK1RtxXDUXDBkKoPvhEKdiyyNthxywvmtFaTW/+P40ltIUITg+sBUq6VyW2vBHWb007XiJlZHhaC2RRWgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LheiKl/Vtf7BbjU7/SpsRqhzLHQQBRwusXawTGMGOUs=;
 b=GSUi/lhSSrzaEDZoc2JrvjWhMDJLL2UKYoqcI8pzGNGgqmduweh6j76S36SSeYLlGGQwdAh7ryhZCNPj2AEjaNQAI8fkgxbPbtZkPlIUhKQv87JJTGnZNg94jM16qZWWgQREJqs6L6OhRZxsp6gUOKqimPrKvmiyVTjusIg9Ggd5B5a0v4VUFpLVv+dYvZoVgdbVW0H57+EQqwQq1DGEiCe/eInA4Dk9tOnIQ2jCA0DNh05Q+q7ySC54uaDhr747LP3kwLGMZuGylWqkLpjmThEE4pvjCcBLoWixMUhw4Jpx6yNbPh10Az1b8Ws2TquBSwlZz/2SdDznr95JF7d9/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LheiKl/Vtf7BbjU7/SpsRqhzLHQQBRwusXawTGMGOUs=;
 b=X5OYT4P4NGmqBc46NIHL4a3lL5ODdjwz/uWTnfgmJo4VSbjnGOoUrGqFxkOEqr6SdBfjL98UmAy+JH/rm5qRWHxH54appDeUTPjZ7ovhayPgTq/DO4quZ6PkAPM/ZfwoHoJGspzxUaEDfQT3Yg+JKn2Tnl18aGl0xbAGcWcX1A4=
Received: from BL6PEPF0001641E.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:e) by IA0PR12MB7532.namprd12.prod.outlook.com
 (2603:10b6:208:43e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Thu, 1 May
 2025 20:47:50 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2a01:111:f403:c803::8) by BL6PEPF0001641E.outlook.office365.com
 (2603:1036:903:4::a) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.25 via Frontend Transport; Thu,
 1 May 2025 20:47:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.2 via Frontend Transport; Thu, 1 May 2025 20:47:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 1 May
 2025 15:47:49 -0500
Date: Thu, 1 May 2025 15:47:27 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing
Message-ID: <20250501204727.ekooijntj6bimxs3@amd.com>
References: <20250430220954.522672-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250430220954.522672-1-seanjc@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|IA0PR12MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b3472d0-10cd-44cf-44e4-08dd88f16fae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/6hwX53LTBJiChX4m1zPKlzMD7N+9alKnyw3lyz4iLHGMcx8INPiKLTYqqWT?=
 =?us-ascii?Q?toa0XekJh3kYxqFyOcUFr0IfHovkFPnf1QyTtTyDjPgEz/W62NklZxOWMS7K?=
 =?us-ascii?Q?8DvEyxoDmN9Od9FjP+LibsMpJhcYTWBMS9TtpZUAfSKRU+V9iYh4EbpPZDfO?=
 =?us-ascii?Q?AgZoVHVPSANWMtNggGkf/6bLX6YYS+JUSRtNqc0dncXRHvFHDssa8exku81R?=
 =?us-ascii?Q?LfNV+mk46J9KIXGOqd7dzfs2YepqmvxlqS/GwZP0QGUDZozFixQkIDtGaau8?=
 =?us-ascii?Q?w2JxxHYEdRSlELEoSoUFFMtvTzoClyVk/sar8Js4Pkb3AOLIxOfCKk5Nzk77?=
 =?us-ascii?Q?bTyRAdCjlKtFEeHa3otGdbbJM/RVh8xFXA1K8Iewbdwu6thnb+ahG82gOsLP?=
 =?us-ascii?Q?ncQjEthv5dV597XoP8Y2rt8ILDoDPsT/T3Wl/65d9xGj3Y89E0+/omCn34yh?=
 =?us-ascii?Q?yngTkKvnGXo/fQBkSWHFOeJyQ6cikLymKlTgCXUgz/udaSD1OUoLjgT3IZNb?=
 =?us-ascii?Q?0ssAe/Ec2FDvF+h0jL4dn7aQm6ort4B/feT3ZWstZxI/wml6MOwjsWdC2YW0?=
 =?us-ascii?Q?Ee+iFtFIV7PMBKKLAvrClqQ8VKoWFwGpTlvW5VmXznsZ1QKqs3FIkM0VZlMl?=
 =?us-ascii?Q?lGeEJWft5e4C1VfWC5ozg2AH7aSD/cCScnOO5PWFWYJinMltbXI5FUciOxxE?=
 =?us-ascii?Q?HszfnH/FJwpDm70biZlDMLhsRH9NLglJox+GGVpVOJgwEVe1eQnjsgwNKU5p?=
 =?us-ascii?Q?s3OioqyO9fCo0hzDiFVbAjUFIO7Me3u5ilJjTwFUlaOgJkKLc8HgR9oW2T8K?=
 =?us-ascii?Q?+z3hQMKNXYz6PnA6tti6xMBSoQSRYoqauEgbtPPQSDwApyLtAFL8/4C+8hQf?=
 =?us-ascii?Q?S8HxrvhxGUIj3Hq0QLZIBPZqnowUkgrLjlyYsTloW3JuVGBNaaHynw6W0kw3?=
 =?us-ascii?Q?vsPoDp+Vs0T5PJFZ6/phiZ5zGodJ4907g/elU8p6XW+axR+ugEBZdXEsU9RJ?=
 =?us-ascii?Q?6yNJNkiT/nF7PRUcVVmkqtd4kOp53Y9s9TaxNJCgT7y8U+e2EIpa9HVZ+vBt?=
 =?us-ascii?Q?MkYPoduo4VRooupbuB1tcSblhik4dbhQHENZDlGPfL4F6kn1rCN8Hk8MaqXE?=
 =?us-ascii?Q?VxdokkPjN5rlwWWCH1piMD8Sl3CnpcMLHIGroDNSZYWHwP9Q1npxOUc6y7Fh?=
 =?us-ascii?Q?caxjydVWJo8iHoXD7LGKbIf/UBTnMgI/eldkVIIu52n9FP03WszV9UqGc4QD?=
 =?us-ascii?Q?X0RYjA8wyWNPEWgpA0M8extvpbEd/MgTTYvnvQkeNpZbbdZ2bFoFhsyl8GS9?=
 =?us-ascii?Q?rs6Epa+Y9CeV2+cR/j5SZjOcCidwj7GD85yH/1PIBozPzRy5UvccmAgHkzQU?=
 =?us-ascii?Q?HH54KQc3sF1L5wr/XJ0GkyCo4mINa82dp7nz0Z9KyTzpqeZpq+dJP98MmxnC?=
 =?us-ascii?Q?GhYS74l+M1alxyCivc6qR8nV9tdzxdtWyYbzFj4UriVnL5+SO/9+MsKsGGzg?=
 =?us-ascii?Q?zGdw/xRS6PmolzeBO2Al34ASmT6FAbq3tt/k?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 20:47:49.8240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3472d0-10cd-44cf-44e4-08dd88f16fae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7532

On Wed, Apr 30, 2025 at 03:09:54PM -0700, Sean Christopherson wrote:
> When changing memory attributes on a subset of a potential hugepage, add
> the hugepage to the invalidation range tracking to prevent installing a
> hugepage until the attributes are fully updated.  Like the actual hugepage
> tracking updates in kvm_arch_post_set_memory_attributes(), process only
> the head and tail pages, as any potential hugepages that are entirely
> covered by the range will already be tracked.
> 
> Note, only hugepage chunks whose current attributes are NOT mixed need to
> be added to the invalidation set, as mixed attributes already prevent
> installing a hugepage, and it's perfectly safe to install a smaller
> mapping for a gfn whose attributes aren't changing.
> 
> Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
> Cc: stable@vger.kernel.org
> Reported-by: Michael Roth <michael.roth@amd.com>
> Tested-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Mike, if you haven't arleady, can you rerun your testcase to double check
> that adding the "(end + nr_pages) > range->end" check didn't break anything?

I can confirm that the fix still works as expected even with the
additional check added.

Thanks!

-Mike

> 
> v2: Don't add the tail page if its wholly contained by the range whose
>     attributes are being modified. [Yan]
> v1: https://lore.kernel.org/all/20250426001056.1025157-1-seanjc@google.com
> 
>  arch/x86/kvm/mmu/mmu.c | 69 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 53 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 63bb77ee1bb1..de7fd6d4b9d7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7669,9 +7669,30 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>  }
>  
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> +				int level)
> +{
> +	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
> +}
> +
> +static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> +				 int level)
> +{
> +	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
> +}
> +
> +static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> +			       int level)
> +{
> +	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
> +}
> +
>  bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  					struct kvm_gfn_range *range)
>  {
> +	struct kvm_memory_slot *slot = range->slot;
> +	int level;
> +
>  	/*
>  	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
>  	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
> @@ -7686,6 +7707,38 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
>  		return false;
>  
> +	if (WARN_ON_ONCE(range->end <= range->start))
> +		return false;
> +
> +	/*
> +	 * If the head and tail pages of the range currently allow a hugepage,
> +	 * i.e. reside fully in the slot and don't have mixed attributes, then
> +	 * add each corresponding hugepage range to the ongoing invalidation,
> +	 * e.g. to prevent KVM from creating a hugepage in response to a fault
> +	 * for a gfn whose attributes aren't changing.  Note, only the range
> +	 * of gfns whose attributes are being modified needs to be explicitly
> +	 * unmapped, as that will unmap any existing hugepages.
> +	 */
> +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> +		gfn_t start = gfn_round_for_level(range->start, level);
> +		gfn_t end = gfn_round_for_level(range->end - 1, level);
> +		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> +
> +		if ((start != range->start || start + nr_pages > range->end) &&
> +		    start >= slot->base_gfn &&
> +		    start + nr_pages <= slot->base_gfn + slot->npages &&
> +		    !hugepage_test_mixed(slot, start, level))
> +			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> +
> +		if (end == start)
> +			continue;
> +
> +		if ((end + nr_pages) > range->end &&
> +		    (end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> +		    !hugepage_test_mixed(slot, end, level))
> +			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
> +	}
> +
>  	/* Unmap the old attribute page. */
>  	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
>  		range->attr_filter = KVM_FILTER_SHARED;
> @@ -7695,23 +7748,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  	return kvm_unmap_gfn_range(kvm, range);
>  }
>  
> -static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> -				int level)
> -{
> -	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
> -}
>  
> -static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 int level)
> -{
> -	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
> -}
> -
> -static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> -			       int level)
> -{
> -	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
> -}
>  
>  static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
>  			       gfn_t gfn, int level, unsigned long attrs)
> 
> base-commit: 2d7124941a273c7233849a7a2bbfbeb7e28f1caa
> -- 
> 2.49.0.906.g1f30a19c02-goog
> 

