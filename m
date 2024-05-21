Return-Path: <kvm+bounces-17866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C9F8CB503
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 23:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C3D31F23170
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 21:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09128149C57;
	Tue, 21 May 2024 21:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4NS0qGAf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609401C698;
	Tue, 21 May 2024 21:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716325263; cv=fail; b=LSTL4ed35dy7QEKaQEvrOxI5wsf3nJtSPjuuounjwWsfN9FeP9M4R8NPOQy8oV7xU3c9Roy9T+JuFQyljf7cjd0lS2NYMWnDer3p4W+9TmMj49xurDkWwxGwONnMl/V641Dh04ptVi6ueRV9LirpcEe+2DIXsvth5SFjy8GAzFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716325263; c=relaxed/simple;
	bh=Y7mX9m1fTGlT/9D+K0BNxqNH/kiS7Ls1TKlkXhNGU6Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GICGMniDnXQD8UddkugVcteWC9SkkL5GhMRByPy9p1DeiJHju9LV43NkDb3G1t098ipB1JYHhVgDCE2y1jbRg9mkeTZwuJGGuymcWyJ+i9SFsAIrzsgLkYIpXjLacWvlLR7cYxBeWWMAKT2FjLsrjRl7VrSLR6JFzrdll7Nhy8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4NS0qGAf; arc=fail smtp.client-ip=40.107.237.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFP5hu1idKODNjyTmkFmEhJ54GcyQojuhguhuPUF5hGWg4+mysj1CIP2bkB9PlVnqZ7zw+k35WV6SywQZ4jLBQpJ//+E4br/dEGHk1LaCqBOXMUyXk7sgXMfFTPdhL5pTi/eQ4m+uDfLT2CfSwD4ktIwPxWySa50geq0qes6MovWO5GRlvoKAvF0cqj4zi+eCIg16Db1nhhlczVtsNVCo8LCUj579BfLOkY5rLv4xPh+kSFjpA9mhg1poI05Nj9y0bS1WVBYtJMdR44SgoaCaUCG2KIxGA1YbDm/YnEuoDzJsbDNFhGCDTb7N7Qv/io1byO1AsmKaN5DPklymPVd/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoqkaYohPt7g/1pwu+1xrnJ+y0WdV9sHfw38aDC9wiQ=;
 b=ESFDOYpOG6qIVNiDD1pa7i6Rf0RYR3YsW6PdLGlu09wNCdzk1q/Fg5M4iDEJUH9cNmnYCDhtCvXN0ANFp3Uo+xcj6BPLfMRXj7w03q1bhBrU+gtyNzcYlQYkzmliA0cVx7q8+7C3CtSad2bVk+xMjtfQA+EcrZwWawo2NU4jaxOm7Rd+Cg+qj9PlV2mg+Y2GcWGRFpYm5E/NE1sT6Wg95syoRZOqwQ1/EOTU7rkO7bRFh7euHbN4SCQeYSGkvA1/2vwR2PQv8gz/1RdCCM7/v1GL8s9n8zShp1y+n0IywwD4v0jTFfbhzK6NLMT8pnrymnqWczu8tzjdMvWvpLbOIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoqkaYohPt7g/1pwu+1xrnJ+y0WdV9sHfw38aDC9wiQ=;
 b=4NS0qGAfCA7fn+ri06aiw7h2LwFCc79yCPYGrdjc7kKM9L0sXm3X7iD3UHusGSXwF8neur5n/tyvCEMJfTBTg5bdKROB7EzC0hi11XsQIR1JKolBESu+UZigMThq62sytEs0caFlOti1FTj2J2q4rGKuCONdawYnvGNz/UR3OaQ=
Received: from PH7P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::31)
 by PH7PR12MB8795.namprd12.prod.outlook.com (2603:10b6:510:275::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 21:00:57 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:510:33a:cafe::df) by PH7P222CA0029.outlook.office365.com
 (2603:10b6:510:33a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.18 via Frontend
 Transport; Tue, 21 May 2024 21:00:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Tue, 21 May 2024 21:00:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 21 May
 2024 16:00:54 -0500
Date: Tue, 21 May 2024 16:00:28 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Michael Roth <mdroth@utexas.edu>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: SEV: Fix guest memory leak when handling guest
 requests
Message-ID: <y5yzweqbmnrbkbcmchqbszayyy4jahsc6qsfccafwr26shguyl@bldfr7cposoq>
References: <58492a1a-63bb-47d2-afef-164557d15261@redhat.com>
 <20240518150457.1033295-1-michael.roth@amd.com>
 <ZktbBRLXeOp9X6aH@google.com>
 <iqzde53xfkcpqpjvrpyetklutgqpepy3pzykwpdwyjdo7rth3m@taolptudb62c>
 <ZkvddEe3lnAlYQbQ@google.com>
 <20240521020049.tm3pa2jdi2pg4agh@amd.com>
 <ZkyrAETobNEjI4Tr@google.com>
 <qgzgdh7fqynpvu6gh6kox5rnixswtu2ewl3hiutohpndmbdo6x@kfwegt625uqh>
 <ZkzSvPGass4z4u9p@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkzSvPGass4z4u9p@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|PH7PR12MB8795:EE_
X-MS-Office365-Filtering-Correlation-Id: f066b04f-1d4d-4f12-33bc-08dc79d91c53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|82310400017|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l9KH5ioVqZ1qIkZ6zEOnzhDJ16lexbA9qt0v2ZZ11GzjmpAxEYBHClpJsXqE?=
 =?us-ascii?Q?26xGzVeZi/ESfZldDv6L4jhJptIiwhjRN0XnhjkiGLEiJ7KPTkMC6dFrdlqz?=
 =?us-ascii?Q?64NMgwAU41HMOA/ucoLTJKrzrn7iRFnl32M1etlNxC+sh616VOu8WmyITubx?=
 =?us-ascii?Q?dV2b1WfSrSYg0+TDWfUbGBRIbXamjDB3/bU8oYW6R+FdinOQyot2gKpkDQ04?=
 =?us-ascii?Q?hDmDotdCDeWwWsv/uFfHJdz6j9kknoEGLlQUNjbswUUJY241+E6S/AuAZDPE?=
 =?us-ascii?Q?Ou19ug98duF+B4dc3bSmwwpvslDBOVFh0UYMpF63Un5OawWNxh8aZw5LCJ2n?=
 =?us-ascii?Q?4dPMMe1EMK/jCrcn/jbfAvonFU0UfBggd8UdZj4hGdxozO6SJInK1N9PA9pP?=
 =?us-ascii?Q?iYZSdX6ijGD2LvrSGAEA1cKW+vBFiCBJkcZNGMeTVqcJg0e7+trmCQpXDizn?=
 =?us-ascii?Q?/o4tJHKo3wAMH8Ay8wcCWMXsSEKuGldUu7JOq2z0IxOe3IQ4IsXaP6lr3OU8?=
 =?us-ascii?Q?ZLdvs3hszXmfN391DzJbl4Tb1OD/uLH5Yqp3YEJ7sHTQuzMt30DZWfUSmD9k?=
 =?us-ascii?Q?VZ3UzcWe+iYHamFk6QoA7MmGgXFe8jYN6ET7SsSntP29bq1UDMZz6WGHHhJ6?=
 =?us-ascii?Q?afmvIfi+vnNRGH8nbyxe8FQmSsvREQVybGtDpO7y8xxem0KjlTe2QUUlQ5Ss?=
 =?us-ascii?Q?4yEUio0kwKadUdpVoF/NmrvKxYF5ekLdIPz83+PQymfTbOi7h8lDiKCrgXsp?=
 =?us-ascii?Q?6pvyE/bSfm9UqyGji1ay1hg6npRl4Ui65HMq17b9XUKmjelUNewGbPzCGNYz?=
 =?us-ascii?Q?t810828w5jSfzLHhoAnr6UhPLkAUirYI1GGhgFt7rVQ34aTTDTIZhv9/27rA?=
 =?us-ascii?Q?7SbKvPbAQI2h6XTzzzBAhPY24T8qCXzY5ZQa7THWp2BFPVeJ4GgUSRB5hM+H?=
 =?us-ascii?Q?wGU830oVH9J2REUT5CMQ3ltilzmHGDE/YZsp47WOSHuX3ZF4O2OH25oD7/WF?=
 =?us-ascii?Q?o1QNzPJWKcg6xFYm5eEY25OWbwB4NS3zPAoXACsGA2+9NCxHwNAhJniglB0U?=
 =?us-ascii?Q?JkhHR9TjJDJijsF3ho1ZVHDEhdAjbSFykWABSm/X4xBN4ANO5reHExx06zwx?=
 =?us-ascii?Q?736iJdYntaIE4gvY/GwdNBOZUALVXd9tk3MQaFVrQefni6NmD1kRippA3b72?=
 =?us-ascii?Q?QNUJvFOC6+peN93/3xNDIFKs2L6s6bMA0j3VSbP3bjjCjlGGwHo6MHmIWN3+?=
 =?us-ascii?Q?5eOSEEyQ0BY6pGpwcCzDyVusnq3noBKgim+3W34gP6z9yhCb02XFd0Wbtu9P?=
 =?us-ascii?Q?qiuGS8xuYoG+4sMC+aDv0zTV5DDVkXuzuAYf8+Dc2Ox9wU7d/7aPXYjwQaRT?=
 =?us-ascii?Q?BGqTBphi0Q++OAgfaiXcBTYvNoRY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400017)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 21:00:56.8284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f066b04f-1d4d-4f12-33bc-08dc79d91c53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8795

On Tue, May 21, 2024 at 09:58:36AM -0700, Sean Christopherson wrote:
> On Tue, May 21, 2024, Michael Roth wrote:
> > On Tue, May 21, 2024 at 07:09:04AM -0700, Sean Christopherson wrote:
> > > On Mon, May 20, 2024, Michael Roth wrote:
> > > > On Mon, May 20, 2024 at 04:32:04PM -0700, Sean Christopherson wrote:
> > > > > On Mon, May 20, 2024, Michael Roth wrote:
> > > > > > But there is a possibility that the guest will attempt access the response
> > > > > > PFN before/during that reporting and spin on an #NPF instead though. So
> > > > > > maybe the safer more repeatable approach is to handle the error directly
> > > > > > from KVM and propagate it to userspace.
> > > > > 
> > > > > I was thinking more along the lines of KVM marking the VM as dead/bugged.  
> > > > 
> > > > In practice userspace will get an unhandled exit and kill the vcpu/guest,
> > > > but we could additionally flag the guest as dead.
> > > 
> > > Honest question, does it make sense from KVM to make the VM unusable?  E.g. is
> > > it feasible for userspace to keep running the VM?  Does the page that's in a bad
> > > state present any danger to the host?
> > 
> > If the reclaim fails (which it shouldn't), then KVM has a unique situation
> > where a non-gmem guest page is in a state. In theory, if the guest/userspace
> > could somehow induce a reclaim failure, then can they potentially trick the
> > host into trying to access that same page as a shared page and induce a
> > host RMP #PF.
> > 
> > So it does seem like a good idea to force the guest to stop executing. Then
> > once the guest is fully destroyed the bad page will stay leaked so it
> > won't affect subsequent activities.
> > 
> > > 
> > > > Is there a existing mechanism for this?
> > > 
> > > kvm_vm_dead()
> > 
> > Nice, that would do the trick. I'll modify the logic to also call that
> > after a reclaim failure.
> 
> Hmm, assuming there's no scenario where snp_page_reclaim() is expected fail, and
> such a failure is always unrecoverable, e.g. has similar potential for inducing
> host RMP #PFs, then KVM_BUG_ON() is more appropriate.
> 
> Ah, and there are already WARNs in the lower level helpers.  Those WARNs should
> be KVM_BUG_ON(), because AFAICT there's no scenario where letting the VM live on
> is safe/sensible.  And unless I'm missing something, snp_page_reclaim() should
> do the private=>shared conversion, because the only reason to reclaim a page is
> to move it back to shared state.

Yes, and the code always follows up snp_page_reclaim() with
rmp_make_shared(), so it makes sense to combine the 2.

> 
> Lastly, I vote to rename host_rmp_make_shared() to kvm_rmp_make_shared() to make
> it more obvious that it's a KVM helper, whereas rmp_make_shared() is a generic
> kernel helper, i.e. _can't_ bug the VM because it doesn't (and shouldn't) have a
> pointer to the VM.

Makes sense.

> 
> E.g. end up with something like this:
> 
> /*
>  * Transition a page to hypervisor-owned/shared state in the RMP table. This
>  * should not fail under normal conditions, but leak the page should that
>  * happen since it will no longer be usable by the host due to RMP protections.
>  */
> static int kvm_rmp_make_shared(struct kvm *kvm, u64 pfn, enum pg_level level)
> {
> 	if (KVM_BUG_ON(rmp_make_shared(pfn, level), kvm)) {
> 		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
> 		return -EIO;
> 	}
> 
> 	return 0;
> }
> 
> /*
>  * Certain page-states, such as Pre-Guest and Firmware pages (as documented
>  * in Chapter 5 of the SEV-SNP Firmware ABI under "Page States") cannot be
>  * directly transitioned back to normal/hypervisor-owned state via RMPUPDATE
>  * unless they are reclaimed first.
>  *
>  * Until they are reclaimed and subsequently transitioned via RMPUPDATE, they
>  * might not be usable by the host due to being set as immutable or still
>  * being associated with a guest ASID.
>  *
>  * Bug the VM and leak the page if reclaim fails, or if the RMP entry can't be
>  * converted back to shared, as the page is no longer usable due to RMP
>  * protections, and it's infeasible for the guest to continue on.
>  */
> static int snp_page_reclaim(struct kvm *kvm, u64 pfn)
> {
> 	struct sev_data_snp_page_reclaim data = {0};
> 	int err;
> 
> 	data.paddr = __sme_set(pfn << PAGE_SHIFT);
> 	
> 	if (KVM_BUG_ON(sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err), kvm)) {

I would probably opt to use KVM_BUG() and print the PFN and firmware
error code to help with diagnosing the failure, but I think the overall
approach seems reasonable and is a safer/cleaner way to handle this
situation.

-Mike

> 		snp_leak_pages(pfn, 1);
> 		return -EIO;
> 	}
> 
> 	if (kvm_rmp_make_shared(kvm, pfn, PG_LEVEL_4K))
> 		return -EIO;
> 
> 	return 0;
> }

