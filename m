Return-Path: <kvm+bounces-6342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CAC82F253
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 17:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B99E9B2408B
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9CE41C6AD;
	Tue, 16 Jan 2024 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P0xh3nEA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F821CF9A;
	Tue, 16 Jan 2024 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqoBRvfnmo++zCfy9f6B6JPuHOm2ia0bkihAX0uZfYAmkLOqsoz+vCkJJK4NGZujhDOnq8KsE/+yhwuIhsfsTuqWFHAHIwjwboj4Iko0PkSswtHGhz124WNFzxJTJN9tipFdMFEYe+nsonBeK0SDLknn9PAGb+0APs7yd9bsRxOpP0EHdELA9tj61JJYAVKTjKx+P9xhXm+WFMVkWmr/KBbTbpC1OXt+yequ+GpyDncoTUxcOeeOpWMw5FkTKF1BV4cM7j5+eHyaU/VT0fuU5R46S0h4oBK2TTLkYX6PyJS1ymdEBcGxo2A35C2+7tLgDStX/wVL27WYHLi0LXZFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+FEpPrfQ137Ofm3UpL8wJV4o5t9ys2yNFdyp5HgxPQ=;
 b=JRwO4aPDi+gjiLSP4Fd6RAb4MBMx3iQ4q99X7P1PkzU927A8PALqJ3sEBwTZL8vcCx4v5ryKfC2NnBFM72ZmTcRvxM40paHfhvz+ydYd7VgeIFWPatPPg7ms/IXpzKpWLIDbEfw0Cwy3Aw9jkFVJ5sMeX2xPCDUCcdG/BmXfZtL7rIqLqg9TSo3MJZYwBznS2wKvVBIZ255luKdXfTvRsd8ISlPGw3XR1MapFHHZD0mCHcKA51c6qEDZlcl5qCbT+QUCASi78ujx/hgnAiq/ESjZeIPqATAQbPrUCZfLlhnchY2xcNsDXhI4rlxrCUHsn6I5dNfrMid4O6PPLaS6lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+FEpPrfQ137Ofm3UpL8wJV4o5t9ys2yNFdyp5HgxPQ=;
 b=P0xh3nEAZJu56wvEEyOCFegPDd8tYVuQSuVCCq/nKgXyVDma1/95utYrDjZ1FTtGMowCNe6k+bjk8V8VRxynS0ZSSMfTLUN7tAi+TeP11/y9msv4TNl8HeKeN6CqF9+uLjgjREWocp7D8ha9Wf9qzWiIgc/qfV9F4ae4PlegwxQ=
Received: from CH0PR13CA0036.namprd13.prod.outlook.com (2603:10b6:610:b2::11)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Tue, 16 Jan
 2024 16:20:09 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::7f) by CH0PR13CA0036.outlook.office365.com
 (2603:10b6:610:b2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.22 via Frontend
 Transport; Tue, 16 Jan 2024 16:20:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Tue, 16 Jan 2024 16:20:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 16 Jan
 2024 10:20:08 -0600
Date: Tue, 16 Jan 2024 10:19:09 -0600
From: Michael Roth <michael.roth@amd.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
	<luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
	<pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, <rppt@kernel.org>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240116161909.msbdwiyux7wsxw2i@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <63297d29-bb24-ac5e-0b47-35e22bb1a2f8@amd.com>
 <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: ab32f600-8604-4c81-b338-08dc16af0224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	H2IdnTPb5C9k7R57RtzTiOeCYTtbwuWTavalT4Q/Wd9H02ovU50FAMn/efZi6KkJZIclIB6mXACRdzb5TLRyFcbml9ESqhu+GJcFOS/X4cjtTrjtbdUeXnrUlrOuFtJe6raz0IaXKVf1BC22Fhlxr8veZy6e3wrE91FnrkgUlDAwM5o7XpSGaVs1OB5+Y66Pxz1FKnDlXDm/cb/wHJupBBu6SGtKxACsIy5DETLsMIeMfAwyaq3im5eCWMWAtmbydN0Fb9tMxXjKF6AD7B2jb3k9lyv+chyN9S7iOdtBr8PUyT38ZNkMPL56LK6kQqMHvqGwk+DKc5p+QZf4f0FHtZ/kmm+G+zPXu3AGcZKp25B1XPRsemtb3M2WWTmupH4Fef1rJwTWUWJWGfnqIGmBpnCb2JveZja9nwrZ5+ewcp8Jsqu5F8ldh7dH6rDu84fNdlXEE+zYfMl8HJIi9MbHJyKEMCOtb/m9HNuERVB72mUCZcZx9ZemcfHTY6gsLla8pdrmgmJtq4lGoBeRu6UhJqmWPakVzd56YCHEW5frahyzA9N7WQe3mhd7fak6NdUGKodDnsnYJ4ydczAXuN9kARs+LgUgUZUixVpGJ3LsMvOeD2SM0EK0v8F4ky5s9nDn6/3pH80PFllYfReR7XsNqVlZsnLohSr7Fcl+pTzlsgG4VxB+njbyCLWd6Th65ASwTC2iQxqjpp9nhQBblenjtjLqjNN4Su6LFm0FCXz+0wZxfkBTizLwNG/hThOFO92G5xz+nsHuvPsU7/K2mheRD+t/AO2T/haoY8GPFvblkcA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(1800799012)(82310400011)(64100799003)(186009)(451199024)(40470700004)(46966006)(36840700001)(86362001)(83380400001)(47076005)(1076003)(26005)(426003)(53546011)(2616005)(36860700001)(16526019)(70586007)(8676002)(4326008)(5660300002)(8936002)(44832011)(41300700001)(2906002)(6916009)(336012)(478600001)(7406005)(966005)(7416002)(316002)(54906003)(70206006)(81166007)(36756003)(82740400003)(356005)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 16:20:09.0034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab32f600-8604-4c81-b338-08dc16af0224
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889

On Fri, Jan 12, 2024 at 12:37:31PM -0800, Dave Hansen wrote:
> On 1/12/24 12:28, Tom Lendacky wrote:
> > I thought there was also a desire to remove the direct map for any pages
> > assigned to a guest as private, not just the case that the comment says.
> > So updating the comment would probably the best action.
> 
> I'm not sure who desires that.
> 
> It's sloooooooow to remove things from the direct map.  There's almost
> certainly a frequency cutoff where running the whole direct mapping as
> 4k is better than the cost of mapping/unmapping.

One area we'd been looking to optimize[1] is lots of vCPUs/guests
faulting in private memory on-demand via kernels with lazy acceptance
support. The lazy acceptance / #NPF path for each 4K/2M guest page
involves updating the corresponding RMP table entry to set it to
Guest-owned state, and as part of that we remove the PFNs from the
directmap. There is indeed potential for scalability issues due to how
directmap updates are currently handled, since they involve holding a
global cpa_lock for every update.

At the time, there were investigations on how to remove the cpa_lock,
and there's an RFC patch[2] that implements this change, but I don't
know where this stands today.

There was also some work[3] on being able to restore 2MB entries in the
directmap (currently entries are only re-added as 4K) the Mike Rapoport
pointed out to me a while back. With that, since the bulk of private
guest pages 2MB, we'd be able to avoid splitting the directmap to 4K over
time.

There was also some indication[4] that UPM/guest_memfd would eventually
manage directmap invalidations internally, so it made sense to have
SNP continue to handle this up until the point that mangement was
moved to gmem.

Those 3 things, paired with a platform-independent way of catching
unexpected kernel accesses to private guest memory, are what I think
nudged us all toward the current implementation.

But AFAIK none of these 3 things are being actively upstreamed today,
so it makes sense to re-consider how we handle the directmap in the
interim.

I did some performance tests which do seem to indicate that
pre-splitting the directmap to 4K can be substantially improve certain
SNP guest workloads. This test involves running a single 1TB SNP guest
with 128 vCPUs running "stress --vm 128 --vm-bytes 5G --vm-keep" to
rapidly fault in all of its memory via lazy acceptance, and then
measuring the rate that gmem pages are being allocated on the host by
monitoring "FileHugePages" from /proc/meminfo to get some rough gauge
of how quickly a guest can fault in it's initial working set prior to
reaching steady state. The data is a bit noisy but seems to indicate
significant improvement by taking the directmap updates out of the
lazy acceptance path, and I would only expect that to become more
significant as you scale up the number of guests / vCPUs.

  # Average fault-in rate across 3 runs, measured in GB/s
                    unpinned | pinned to NUMA node 0
  DirectMap4K           12.9 | 12.1
             stddev      2.2 |  1.3
  DirectMap2M+split      8.0 |  8.9
             stddev      1.3 |  0.8

The downside of course is potential impact for non-SNP workloads
resulting from splitting the directmap. Mike Rapoport's numbers make
me feel a little better about it, but I don't think they apply directly
to the notion of splitting the entire directmap. It's Even he LWN article
summarizes:

  "The conclusion from all of this, Rapoport continued, was that
  direct-map fragmentation just does not matter — for data access, at
  least. Using huge-page mappings does still appear to make a difference
  for memory containing the kernel code, so allocator changes should
  focus on code allocations — improving the layout of allocations for
  loadable modules, for example, or allowing vmalloc() to allocate huge
  pages for code. But, for kernel-data allocations, direct-map
  fragmentation simply appears to not be worth worrying about."

So at the very least, if we went down this path, we would be worth
investigating the following areas in addition to general perf testing:

  1) Only splitting directmap regions corresponding to kernel-allocatable
     *data* (hopefully that's even feasible...)
  2) Potentially deferring the split until an SNP guest is actually
     run, so there isn't any impact just from having SNP enabled (though
     you still take a hit from RMP checks in that case so maybe it's not
     worthwhile, but that itself has been noted as a concern for users
     so it would be nice to not make things even worse).

[1] https://lore.kernel.org/linux-mm/20231103000105.m3z4eijcxlxciyzd@amd.com/
[2] https://lore.kernel.org/lkml/Y7f9ZuPcIMk37KnN@gmail.com/T/#m15b74841f5319c0d1177f118470e9714d4ea96c8
[3] https://lore.kernel.org/linux-kernel/20200416213229.19174-1-kirill.shutemov@linux.intel.com/
[4] https://lore.kernel.org/all/YyGLXXkFCmxBfu5U@google.com/

> 
> Actually, where _is_ the TLB flushing here?

Boris pointed that out in v6, and we implemented it in v7, but it
completely cratered performance:

   https://lore.kernel.org/linux-mm/20221219150026.bltiyk72pmdc2ic3@amd.com/

After further discussion I think we'd concluded it wasn't necessary. Maybe
that's worth revisiting though. If it is necessary, then that would be
another reason to just pre-split the directmap because the above-mentioned
lazy acceptance workload/bottleneck would likely get substantially worse.

-Mike

