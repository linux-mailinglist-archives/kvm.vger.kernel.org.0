Return-Path: <kvm+bounces-43602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5922A92EB0
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 02:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1D014A0CC3
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 00:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7FCA945;
	Fri, 18 Apr 2025 00:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RNRcb3Qi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26033442C
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 00:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744935180; cv=fail; b=Cy9sRoVx6wzfAtaepUlFmadF99o6iZzNFTKvMhTI0/fcLanPNktIZ5abhasBydFUwjXH5vrytC+kSbaMxngwOb1e6OnOjjFC2H8RtqOu8/0m7tu3YjslVmWJ11IeRq6qyswVzGeJAM+U7V1oR4Tpk+RDJl1GajyqMhXETWpWTqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744935180; c=relaxed/simple;
	bh=86sMgO5j1bKlB4BmaRy8AtBt/JyeywSyZVZn3H5BhnM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b11WTWauNvTf4M9BctajpeBhzqsfyc3jntYGVyZy9Y1vwCQb7SC7vnt3sxti4nBrcZmYLbWIOd6wiyLxJKlL/Rwc9wJu6tTAkxKElS5cMyEUOdee0Imr04npUYI/MxknyCO+Tjt1unHbc+uKZgVcDNHBttFu4s9Fs6Y9HlMRuxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RNRcb3Qi; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BAPm1zcH2MV1SJLSywwWbufR0laLHLdVjYGPd3CCAW48AjnlW8HoBN6Gn9+TmoEaM1vBEexJ0TgeZq8RoyAVocUS7yfuutLL+TFLn09n4wzhDoCO6VT1qyWCY++keRYaSFrUMdfdGznP/0omktmjv4xpygsKqSGY5jVDdJc26fG9DbmqbC7Cef1/oZ6HDDnN3u2prYahesqFvbyypGzOpKpwxN4zQlWda027WH9QT1oFMLQ4+oo1w3Vv4smdObcqqf+egqqb9vRhZav59stdqb10LiNeDQ6VBohPqSqmEXAxBIO24wBgcYK2YXOPVV5iCYimiq76gOWt6Si6XO/ldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGoodR00V5msKkz/K0ldBWUiWgubXkNL8t4v255fRxQ=;
 b=PUHTePOQfty7AkxgyKNjbFw2ew2kNZ2v27hH05cxqq7yyaIkATAR6POSBrJ/rOMsKtI4tLFvRDdJMm5nADC71QT9cQi4HnxJatNuyHGjLD7l+l2f+09Fzv+7IIGfGs6I4Mr+w1b1iI2XTtfwt7qT4xY9x1f0kfuCaKbP3xbbNNL7RUn3vVQYMM19qrFDGhtMYzWgWgmdxNy6zzGKKAOGNMYRZbHGTxrmbURlusd6AGLy+8dW6iUCEKxOYpMQXY6tW+QegmsrZkLGUXTSE72MmogbZgHLIaeHFjYMOVuS1Q/q5Gxvd1P+DBU22Oj8jwzidh7/rIsX6kgdbUhhHyRKXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGoodR00V5msKkz/K0ldBWUiWgubXkNL8t4v255fRxQ=;
 b=RNRcb3QiBI4RFfYtRJzht0P60eFoiE3wsGKnGWOMcusEMVGjvi3C5Bf/M8/m9zNDd0o8dRZkXCTJIeuW2RlIzbMtLgJs6zSmD7d6ULimLXOq48Td3nk+iULlMgio1lFvVeig2KPes3eGdvgKRrPk6MpMJXrW3yImgv6DIMGteuI=
Received: from CH3P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::12)
 by SN7PR12MB7884.namprd12.prod.outlook.com (2603:10b6:806:343::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Fri, 18 Apr
 2025 00:12:54 +0000
Received: from CH2PEPF0000013D.namprd02.prod.outlook.com
 (2603:10b6:610:1e8:cafe::2c) by CH3P220CA0013.outlook.office365.com
 (2603:10b6:610:1e8::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.22 via Frontend Transport; Fri,
 18 Apr 2025 00:12:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013D.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Fri, 18 Apr 2025 00:12:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 17 Apr
 2025 19:12:53 -0500
Date: Thu, 17 Apr 2025 19:12:37 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>
Subject: Re: Untested fix for attributes vs. hugepage race
Message-ID: <20250418001237.2b23j5ftoh25vhft@amd.com>
References: <Z__AAB_EFxGFEjDR@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z__AAB_EFxGFEjDR@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013D:EE_|SN7PR12MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: 0accda7c-44e5-4fa7-367c-08dd7e0dc399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DHUGPWndmxWnDoalc2ndi4LSsL5GpwTn+5SDJy9aPaBUynZ+qGsIWrvQ9OZq?=
 =?us-ascii?Q?P/3EwINQI5cm5kkhPe03RV0WCqHPiBis6/18I9n1Ix9CG0QpUGWciEBkArjZ?=
 =?us-ascii?Q?SxCAYCUfw4b/0qtU7PPnBpMeQSMzY3tBOSETo4lD5SWg0PKuJH+noLmOc6df?=
 =?us-ascii?Q?UUU5YSD43CGniMm7Oo1LNaopdbWFxBprK6K4ZNHP80AGmk37QpmNx26TLkMJ?=
 =?us-ascii?Q?kvVA6SrZ6e0AjCqLXqSK51oDd/JqLx+0a57YEGcD5I6//gyWhybyebM0dBEp?=
 =?us-ascii?Q?dKRrPzVpKnVrta/G4ZoMyDrsf3lVcjIphkcd7Qa5DyJESdK5XiA4CMwcAl0O?=
 =?us-ascii?Q?/BhLIsVtJZ8LIqrkLHIE7+QcCM73CK4QzlRdeECAoEQPgbXr3RV/XnNXt0CK?=
 =?us-ascii?Q?7z1lG/gNgVrGUF787jZNARqBbNyWOEvixvNM7Of4uQI0J6kvsTuFafzBwC8b?=
 =?us-ascii?Q?h2ROMDYxQFIXozTo6Z/wyBessFEpCoPkvlzV5dlgHoXaaQyjmkYiHe22fRIG?=
 =?us-ascii?Q?6jxtGH0miuiX3GNxxxPNC3VRTAmeuf4W1xZg6RaRYUAEwEJFcUGoF6G6nFtO?=
 =?us-ascii?Q?Kr/c/og3NnEBQbo0S6bhq4XpPlw+32u0lz/XQaxhYKgbsMd+ehQxQNum44pD?=
 =?us-ascii?Q?+MLH7SbLjwIyis+KTg1BESfhoJta+lV8U0OtY3wmWw6auqTVOwtGFYgML2/B?=
 =?us-ascii?Q?O+vOn5PVRmWUK908zOjHT+0VuA9CjIb6Rx6yWvahUSxNI08c1m1RnJOrMLzp?=
 =?us-ascii?Q?bh0lDb81VjrSOhmX86lIcUThw06rQ4RyrDNEIqmkLxIjc1lv0On8SIaKcUwh?=
 =?us-ascii?Q?VTDsumDfFyW4FzpoVcOwYeJ6hq5ei0Jk0S6hm9+nLQVI39jIn241sfLyHPqm?=
 =?us-ascii?Q?B7b4ukPlGkVICC3v2DOXOGFVooqV1TdmhJFeQoL0nnqYPMYjKEN+2ojkq1yr?=
 =?us-ascii?Q?sHviBMD+4oaVVDECj619xCe8fqLDeUl9B8RtDu/wPtCrvfv07W6wW07Yc+eO?=
 =?us-ascii?Q?qEq6+X221hKj4hnmwrvGwrRgYOFCPa7/eJJJxwy5AMdAnKXjmhJp1ij2xIsZ?=
 =?us-ascii?Q?JUJEglcREXhFs2LlLeGGlBVqM1yvO9NVvGiMbQuJ09tyvLw8Rr/OTsFp8dY6?=
 =?us-ascii?Q?iA8UPhOsjsR70n0LjCPXoThG54GpcWhbpmo4Iiwfx/VgjZ/aZtL+AsGOKGj0?=
 =?us-ascii?Q?tSglZlJMP2LpKs12cAlChV7Hzev9uhccDedpbh5tzQtCqcuL6MSCTMuxfpvO?=
 =?us-ascii?Q?aLZsCYDJpS3dgneZ0Y7Em8d2Xnae9aQhGoxHQ7iAfHBSyY/RF61uN/uId88U?=
 =?us-ascii?Q?GwYLq2X5ODADkAQO1BQyhTYKXbegtMgMkq3kvnAs++sz9UofXpgi0qzRlnr+?=
 =?us-ascii?Q?m4q6QHioW98PDvH7wumeGrjp1YvugKOIKR7/Vqls/a+5KJMZsUj/EZi+vIyC?=
 =?us-ascii?Q?KHM/EZ6snRnwPeLPmg8f4DrPLHEViARvL5Je2A4a5d6UQeh6JgblmdJTqr5C?=
 =?us-ascii?Q?288k0ZkqU19EagnrlEpPNzLwUJ1bKvaBZmc/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 00:12:53.7121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0accda7c-44e5-4fa7-367c-08dd7e0dc399
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7884

On Wed, Apr 16, 2025 at 02:34:40PM +0000, Sean Christopherson wrote:
> Mike, can you give this a shot and see if it fixes the race where KVM installs a
> hugepage mapping when the memory attributes of a subset of the hugepage are
> changing?
> 
> Compile tested only.

Hi Sean,

Thanks for the sending the patch. Still working on verifying this fix on
the real setup, but some hacks to artificially trigger the original case
and verify the behavior seem to indicate that this patch does the trick,
but I did have some comments below.

> 
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 16 Apr 2025 07:18:19 -0700
> Subject: [PATCH] KVM: x86/mmu: Prevent installing hugepages when mem
>  attributes are changing
> 
> When changing memory attributes on a subset of a potential hugepage, add
> the hugepage to the invalidation range tracking to prevent installing a
> hugepage until the attributes are fully updated.  Like the actual hugepage
> tracking updates in kvm_arch_post_set_memory_attributes(), process only
> the head and tail pages, as any potential hugepages that are entirely
> covered by the range will already be tracked.
> 
> Note, only hugepage chunks whose current attributes are NOT mixed need to
> be added to the invalidation set, as mixed attributes already prevent
> installing a hugepage, and it's perfectly safe to installing a smaller
> mapping for a gfn whose attributes aren't changing.
> 
> Reported-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 63 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a284dce227a0..b324991a0f99 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7670,9 +7670,30 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
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
> @@ -7687,6 +7708,32 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
>  		return false;
>  
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
> +		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> +		gfn_t end = gfn_round_for_level(range->end, level);
> +
> +		if ((start != range->start || start + nr_pages > range->end) &&
> +		    start >= slot->base_gfn &&
> +		    start + nr_pages <= slot->base_gfn + slot->npages &&
> +		    !hugepage_test_mixed(slot, start, level))
> +			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);

For the 'start + nr_pages > range->end' case, that seems to correspond
to when the 'start' hugepage covers the end of the range that's being
invalidated. But in that case, 'start' and 'end' hugepages are one and
the same, so the below would also trigger, and we end up updating the range
twice with the same start/end GFN of the same hugepage.

Not a big deal, but maybe we should adjust the above logic to only cover
the case where range->start needs to be extended. Then, if 'start' and
'end' hugepages are the same, we are done with that level:

    if (start < range->start &&
        start >= slot->base_gfn &&
        start + nr_pages <= slot->base_gfn + slot->npages &&
        !hugepage_test_mixed(slot, start, level))
            kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);

    if (start == end)
        continue;

Then what remains to be determined below is whether or not range->end needs
to be additionally extended by 'end' separate hugepage.

> +
> +		if (end < range->end &&

This seems a little weird since end is almost by definition going to be
less-than or equal-to range->end, so it's basically skipping the equal-to
case. To avoid needing to filter than case, maybe we should change this:

  gfn_t end = gfn_round_for_level(range->end, level);

to

  gfn_t end = gfn_round_for_level(range->end - 1, level);

since range->end is non-inclusive and we only care about hugepages that
begin before the end of the range. If we do that, then 'end < range->end'
check will always be true and the below:

> +		if (end < range->end &&
> +		    (end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> +		    !hugepage_test_mixed(slot, end, level))
> +			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);

can be simplified to:

    if (end + nr_pages <= slot->base_gfn + slot->npages &&
        !hugepage_test_mixed(slot, end, level))
            kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);

Thanks,

Mike

> +	}
> +
>  	/* Unmap the old attribute page. */
>  	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
>  		range->attr_filter = KVM_FILTER_SHARED;
> @@ -7696,23 +7743,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
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
> base-commit: fd02aa45bda6d2f2fedcab70e828867332ef7e1c
> -- 
> 

