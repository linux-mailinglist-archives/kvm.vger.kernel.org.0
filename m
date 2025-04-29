Return-Path: <kvm+bounces-44765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A4FAA0C69
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00EEE9817CC
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 12:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B15329DB61;
	Tue, 29 Apr 2025 12:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hDmiXgv/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B4B54654;
	Tue, 29 Apr 2025 12:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745931478; cv=fail; b=Z6xTZib3tcMQMxbmL2v+T2gY9GwFQ2t8uXDZ7VlYHuQdnJUawPJ27Mmvk6Tgpraa7da71dQnfWHrLnskYy8ZYXMvQtrDT8plF9ukSRD9KFdRAPkhYOoLtjzBO6KFx8rx1gZG1RLIT0qgHTAt9xg+xaReiCrHx5X2dGGjb62aGiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745931478; c=relaxed/simple;
	bh=PRqJCQMfIYXvsQaHwtHCEQmqcK+EZC0cRBrBTaBKHVk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQzL2RIjFCx4aokJgmPF1PARrDwIFC8BBnUI6Th+15Ww1RlUgq2SObLqB+ZKiTYtBQqxfaG7mTlbVxYu9n+UfQgxjtnIcu8WQnZsBn2t148QW7hYPFqd0Fe/ThMJbz9L2Y/qcjl7k9MtJaoOBDaX0hQ3hwQvBn3/OJ+DjyWY3J0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hDmiXgv/; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g7WVTfVizvhdqTp3KR6Hn1PRAYYkjTUezbHiq9nKMdP7qV3s5Cp4I2Xi/UGXNrlpbvrH33qLkoWeJWltuMpmo9yB2r+IWreGKBnt33D7U7E2agi41Wd2bbNbj1zEUkV+PaNsTOjmvJAu0eFdhjW0VYNFITuTrwHJDVQlfmLctzcpwJZe/Bk5l4vo1yDtaYpQPPcpMNl69CKPLbvTl/wJIgfZMv22zjd4He+Ek4SJpZGsr//ZQFhGClwc71Zd7kp6HFwYdIoTC+UvzqySdL1pGzDodXu2Me+E7r00ltXvlsNjdfYviZzVppOTUmbz+HdPM+fSz5tI0QmhA4kCn6X3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9gg/3OiSHqyikjmsCVwccGncDMV4UFzxVy1NW1oiI0=;
 b=mry8YloRCBfGs0+zrhY/hPeeHzsMMwdnYbj7iVgup5rMmOPTEwcmPldbr7Oc2oBOVVnX6dqNe5J2dx8RaY8iU0gpjw/la0Fl1UVUyJD1OnDf/pSuRzMWeiFgo0VzgPCjEobnHA1gg8+sGUArJQOvsWQYfwtidNhTpOOpFNFtqEQzdf4sku7B9+YXWnrFI8nR5ab5gvtbOatNOmJN/SVYmce8G+/bqDEuvqAP603D7Vs68YSetqkGwx/z2aothRw/ImsWcPtn7DzLRYaBwd5fswRHh4yx6bqDp8hJf2JGLX05z+tFqoJmcqHsn5c91h9VU2+29Ju2cnscco8gs1cLYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9gg/3OiSHqyikjmsCVwccGncDMV4UFzxVy1NW1oiI0=;
 b=hDmiXgv/nKHrMI3PpinTGNBN6u5UNhW5Cza+29Sb7k9mirmf1794TeqtF3MI01b/2IXREaJZYzrhxro5GYIDLnh8CPUU4AXuF2LJ91+qPagUTJ3odOvQUQGwHBZFz71DnakCc1RFZ1DIlq6qL+ILdqkij4G2unnEp6+0kEGewi4=
Received: from PH8PR20CA0004.namprd20.prod.outlook.com (2603:10b6:510:23c::12)
 by MW4PR12MB5666.namprd12.prod.outlook.com (2603:10b6:303:188::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Tue, 29 Apr
 2025 12:57:54 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:510:23c:cafe::9a) by PH8PR20CA0004.outlook.office365.com
 (2603:10b6:510:23c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.40 via Frontend Transport; Tue,
 29 Apr 2025 12:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.20 via Frontend Transport; Tue, 29 Apr 2025 12:57:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 29 Apr
 2025 07:57:53 -0500
Date: Tue, 29 Apr 2025 07:57:37 -0500
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing
Message-ID: <20250429125737.ygddoivogz2pf4mj@amd.com>
References: <20250426001056.1025157-1-seanjc@google.com>
 <aA7aozbc1grlevOm@yzhao56-desk.sh.intel.com>
 <aA-VrWyCkFuMWsaN@google.com>
 <aBAqAfBQRwP5Dx91@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aBAqAfBQRwP5Dx91@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|MW4PR12MB5666:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dfa4c73-9a81-447a-04dc-08dd871d74e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mOAPT9mVNj0fzmcJlBNmzvcpt7jRvCbalss6kjDGJSpKrONDP7kRTLVEP1X2?=
 =?us-ascii?Q?+b8/lQyOGMOtnKqzk6jM/vddVptgwxpzIzT1nSdCrVujvbEohSWMi9DjK0A2?=
 =?us-ascii?Q?aW0Amh0GxHJr9k9KCgJCXyZIKyiRinLTM8u/LniR/ov11Wc0TOSPjB3HzK5y?=
 =?us-ascii?Q?BZapJaGGltfXLUgdGTVaEx4P1JLiaLv+Uk4s2lQtgQVzCkRrJDu32rW8jbrX?=
 =?us-ascii?Q?rvHiw7mlygVtyTEHnbEIKOlg0AIqZqiZD9s89S48v2dyXL9QYVi86UHj9z5l?=
 =?us-ascii?Q?h19aZP1IPlKkNEYR+ReVtlCmW3vIUoBQJ43l/JlovA/A0c55eGzge4EcgcBt?=
 =?us-ascii?Q?jW7zZtmTpLnbvp/RnnpiSfCvnv9bJxe7kkks9FrsutHvT4QDBRgJyTGf2iW+?=
 =?us-ascii?Q?1r4MpjjN7lvbec7CuCk+sHXmVdynECzF7Giq7JYj0261GpCKCIZh3CdAUPbC?=
 =?us-ascii?Q?kB8ebaTiaMgdc7wpmZ6UwuTHoSKoIBD0a5+M7DyIfKDIpPLX3S+Xms6vIeZl?=
 =?us-ascii?Q?0EWMdXtuALynzy4kqT3ndvGDsBsY0QoBfZS/ilkim+ilgPRmzkKGqAcROrx+?=
 =?us-ascii?Q?byYbHFXpQskXpFyo3z1HQB/2eHYFjDxalog23bJnws3tk1xaYdVv9FpenRdz?=
 =?us-ascii?Q?Sr6gn4YOwcfHkhKU0tX8lWm1yHhbhcVn90lqxk7DCkKlhjU2Lj8MevjG4rAq?=
 =?us-ascii?Q?kGlvEdKM78oTJ2zVhNBjCG2JOyOCuoUoCep2xS4BUGOXNy4CFr1ooPfoX3Ed?=
 =?us-ascii?Q?wQg+EssshQA25awHhqXFsx6CbM2UKlO4NpyaYJdHCBz8tMTZ7OAurYvf3CSF?=
 =?us-ascii?Q?3Uq7mGS6xH6+4r0FFcrDfzJbAgK2Ph4aRe9lUjqNJ3VI3OVTYpT8nq25au3l?=
 =?us-ascii?Q?dN/ey34X51Jh7zLwq1a5SUzKbE483I68PIRWORmnIeTa66scqYIvtKlzcIWw?=
 =?us-ascii?Q?9rwCqBdS5laK9u+SwzNXISRJwvN14gbFQcMlaqUzQlS0HwxEKGPXgr9U696Y?=
 =?us-ascii?Q?CKnU3wKTn4IOvItzgHkdXSbrGzOEdduQvqVu70nphsrA38tzXEgyPZMTnTqe?=
 =?us-ascii?Q?yrhuteETiS8a/MGe5clecy2Cz07Wdghe2LkMFXVQmq/vgsel5waAuK9zN+/K?=
 =?us-ascii?Q?sQLIByJyRT9bFLuQR0aQizB2V61l7vOsuXIhdjFHGfWxSTfG6hvpEOEkEO8K?=
 =?us-ascii?Q?fCohwzn7ySzLkaoLliC7Nd3ctPOFm9TsCaDYB3uG8KbwhUPr9kmsP1Q08ewV?=
 =?us-ascii?Q?s8ic0JADTYsYP35oyR5y9y+Z4nPvPlVTSAJySE39IiZHcOO4zhQ07tUNqx+W?=
 =?us-ascii?Q?QrENxB9W7cZ5lt2QhyZnKnCQG2+GgvcUsT4qh8jFuDqAW5eiclNTYyRUSm9P?=
 =?us-ascii?Q?qm9uIbUKsitl7JgRoENDvwLm+eIIQkdCgfDCgQRc/s6+GXga3dObhvpyTb9y?=
 =?us-ascii?Q?vJ/yIhW7BHjouvgaXABemQg30CmDT7071+5w4z5wSuzU4NcIqp3kYwQsTM5n?=
 =?us-ascii?Q?z2rLGLjQZe5qsdsnDhj7po68WzvKJChbaiL7?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 12:57:53.9705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfa4c73-9a81-447a-04dc-08dd871d74e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5666

On Tue, Apr 29, 2025 at 09:23:13AM +0800, Yan Zhao wrote:
> On Mon, Apr 28, 2025 at 07:50:21AM -0700, Sean Christopherson wrote:
> > On Mon, Apr 28, 2025, Yan Zhao wrote:
> > > On Fri, Apr 25, 2025 at 05:10:56PM -0700, Sean Christopherson wrote:
> > > > @@ -7686,6 +7707,37 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> > > >  	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> > > >  		return false;
> > > >  
> > > > +	if (WARN_ON_ONCE(range->end <= range->start))
> > > > +		return false;
> > > > +
> > > > +	/*
> > > > +	 * If the head and tail pages of the range currently allow a hugepage,
> > > > +	 * i.e. reside fully in the slot and don't have mixed attributes, then
> > > > +	 * add each corresponding hugepage range to the ongoing invalidation,
> > > > +	 * e.g. to prevent KVM from creating a hugepage in response to a fault
> > > > +	 * for a gfn whose attributes aren't changing.  Note, only the range
> > > > +	 * of gfns whose attributes are being modified needs to be explicitly
> > > > +	 * unmapped, as that will unmap any existing hugepages.
> > > > +	 */
> > > > +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> > > > +		gfn_t start = gfn_round_for_level(range->start, level);
> > > > +		gfn_t end = gfn_round_for_level(range->end - 1, level);
> > > > +		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> > > > +
> > > > +		if ((start != range->start || start + nr_pages > range->end) &&
> > > > +		    start >= slot->base_gfn &&
> > > > +		    start + nr_pages <= slot->base_gfn + slot->npages &&
> > > > +		    !hugepage_test_mixed(slot, start, level))
> > > Instead of checking mixed flag in disallow_lpage, could we check disallow_lpage
> > > directly?
> > > 
> > > So, if mixed flag is not set but disallow_lpage is 1, there's no need to update
> > > the invalidate range.
> > > 
> > > > +			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> > > > +
> > > > +		if (end == start)
> > > > +			continue;
> > > > +
> > > > +		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> > > > +		    !hugepage_test_mixed(slot, end, level))
> > > if ((end + nr_pages > range->end) &&
> Checking "end + nr_pages > range->end" is necessary?
> 
> if range->end equals to
> "gfn_round_for_level(range->end - 1, level) + KVM_PAGES_PER_HPAGE(level)",
> there's no need to do other checks to update the invalidate range.

It's not really necessary, but yah, it would avoid an uneeded call to
kvm_mmu_invalidate_range_add(), and it would more closely match the
logic for the 'start' hugepage which similarly skips the call in that
case.

-Mike

> 
> > >     ((end + nr_pages) <= (slot->base_gfn + slot->npages)) &&
> > >     !lpage_info_slot(gfn, slot, level)->disallow_lpage)
> > > 
> > > ?
> 
> 

