Return-Path: <kvm+bounces-6347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B11282F2A4
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 17:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63AD2B23493
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5331CA91;
	Tue, 16 Jan 2024 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="09uBgXnu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A311CA80;
	Tue, 16 Jan 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W26ph9xzOjwGJXAC67YIZwb+epj/+FPMFi98WtjrMBsu9WIaCXkvMJNLsk6JWEjJ5amQxYaRQSssbgKsEOau9UNMaQeSXVKNuqbey1UR2UyjzR2P5iTXwSgc+JZArVbuQEyLHPyeJs5FVRUn8cU3Do22zH35vqMvNH75bBQaMAaip4QBpuustMvIyPgLKan8SS/jzuCW8qGktLBFaW88P9MtrggitolezpNloge43fhFwvtDXu6n9kau8Rtpr2+NTKUHl6XV0uhZIQIfweLsHkzb4AjkG3GXf+MlIt7ydFsjlIllqEupUyyDMIsHl6Usq6tCULp6Yl8DCW8FdzUtKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOxuYkMnskfLXsQJUZTf6Lccs54q6PW1/+t64c/Ea98=;
 b=iP1yj4+y0llOWsVujrvzM1OqcrGBI0fvUK9bU2BWM1iON9NOVnsmG7mjTQWoazcmS0nwO3Ty2sFqiEOE8ve5qKA0BuEaZ5AjaBJkq4oTD1PuRCVV4BEjZOi0XjKSdL83Rl+fkF3ZGknfwnbU7zSrzPl/ZOV3o2xYYep6th862U4YhV/lCAHvl5foOhBsEHpbEIj3K863UdS0baVe2gPRDQaJsTuD17Wf24NwSCC2BtUQ0ER0LZakJbVfKPPlbzf1qh+IVhAapEZIE+hR8Q6ci+I41QXgYgIVSP3MzsoaUIWSvBHQ8gEUK5j9aPqCxHbkDg16AYkSJ4jkgWc4bZp9NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOxuYkMnskfLXsQJUZTf6Lccs54q6PW1/+t64c/Ea98=;
 b=09uBgXnukGNdXNTNro32x5rE7Hmd0HkElAmldyPDs6+0jgRuAp6uwNr7RIpEshBr4jU+YvF9/ag6TFbyrwJmUkTDyVvAzDg7N/eIA45oZQYGu+6feX5FCUyEi8BlzC/Q74dBfMMczOzQkdT6JrMduEHswp5GnOmtG453tucNqRU=
Received: from DM6PR03CA0057.namprd03.prod.outlook.com (2603:10b6:5:100::34)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Tue, 16 Jan
 2024 16:51:44 +0000
Received: from DS1PEPF00017096.namprd05.prod.outlook.com
 (2603:10b6:5:100:cafe::59) by DM6PR03CA0057.outlook.office365.com
 (2603:10b6:5:100::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.26 via Frontend
 Transport; Tue, 16 Jan 2024 16:51:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017096.mail.protection.outlook.com (10.167.18.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Tue, 16 Jan 2024 16:51:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 16 Jan
 2024 10:51:43 -0600
Date: Tue, 16 Jan 2024 10:50:25 -0600
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
Message-ID: <20240116165025.g4iouboabyxkn5nd@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <63297d29-bb24-ac5e-0b47-35e22bb1a2f8@amd.com>
 <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
 <20240116161909.msbdwiyux7wsxw2i@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240116161909.msbdwiyux7wsxw2i@amd.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017096:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 65bcccdc-9391-48d8-bdbe-08dc16b36c0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sRoWkZNIlP1GEDEGgrKB+PXthqJflfoep0oNkZhWyF4Ss3R2dhPNuwxLTtIRp2UyP3nxEHkTS5jDxk76OkedhxI++8pbAV3QNVhrmp8LeAQiRnP7TeNSCa7wJqb67SPDev61XTKzKqPoScnGVEYVzFOsmPQjyFFxG6A0m8YLxP8P1uDPAqs6ddx4Xe78ix+g2z+WgyuF3CAjmIuFunEqDctVGfIKZTfltM4N0sOyyy/Rylr6AwezQWIHhNlrPmyepQgdKPwCh0k4ONYKLeB9uN2WcUts15fEPtXNfXxIBOoVbXzM8FqGDxemInexoxKdb8kk/OEbUPFg4kmFGI80489NHci8qv5t+Mk7ikvy0xl9X/mzaI2P+KSxdzHdBDWJ0zA8dwGsndTk1cUh9B88/nrOtCQqaE2xtGNIhn5KlCKZojJhPSGjm1ohKhRSyv6YiG3rWE3vA0F64AZ57UonCs4CagTvSO0CTRGE9+6SPKSl0urzERfeqZKAqJOjiapYKwz44pIxub5PdMkNzRRrmBLO+BoP/ubbOjwMppxsz86s0ZNPhi7iafAE4FQShffleuskq0ER57hfJcG3g/xSscxcG48s0ievDm0o8FzHKufKjXHg0ci0I4GxWliWedTnU9pa63nBHio8Lo9UAwtZv1QT+VlFBk60P9LKCjX0u++f5DjIg/Q608ITVplLDSD9f9LFeUXNGICI0KVF1Fu2NQUc4tW4qwo6fiEkArW3sj4t+DdqJA+ZRkLMIY0juq7ob29agqND+BVCTvuu0x6VJg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(451199024)(64100799003)(186009)(82310400011)(1800799012)(36840700001)(40470700004)(46966006)(36860700001)(40480700001)(356005)(82740400003)(40460700003)(86362001)(26005)(16526019)(1076003)(426003)(2616005)(83380400001)(36756003)(6666004)(47076005)(81166007)(336012)(70206006)(70586007)(316002)(54906003)(6916009)(44832011)(7416002)(7406005)(2906002)(4326008)(5660300002)(8676002)(8936002)(478600001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 16:51:44.6783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65bcccdc-9391-48d8-bdbe-08dc16b36c0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017096.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496

On Tue, Jan 16, 2024 at 10:19:09AM -0600, Michael Roth wrote:
> I did some performance tests which do seem to indicate that
> pre-splitting the directmap to 4K can be substantially improve certain
> SNP guest workloads. This test involves running a single 1TB SNP guest
> with 128 vCPUs running "stress --vm 128 --vm-bytes 5G --vm-keep" to
> rapidly fault in all of its memory via lazy acceptance, and then
> measuring the rate that gmem pages are being allocated on the host by
> monitoring "FileHugePages" from /proc/meminfo to get some rough gauge
> of how quickly a guest can fault in it's initial working set prior to
> reaching steady state. The data is a bit noisy but seems to indicate
> significant improvement by taking the directmap updates out of the
> lazy acceptance path, and I would only expect that to become more
> significant as you scale up the number of guests / vCPUs.
> 
>   # Average fault-in rate across 3 runs, measured in GB/s
>                     unpinned | pinned to NUMA node 0
>   DirectMap4K           12.9 | 12.1
>              stddev      2.2 |  1.3
>   DirectMap2M+split      8.0 |  8.9
>              stddev      1.3 |  0.8
> 
> The downside of course is potential impact for non-SNP workloads
> resulting from splitting the directmap. Mike Rapoport's numbers make
> me feel a little better about it, but I don't think they apply directly
> to the notion of splitting the entire directmap. It's Even he LWN article
> summarizes:
> 
>   "The conclusion from all of this, Rapoport continued, was that
>   direct-map fragmentation just does not matter — for data access, at
>   least. Using huge-page mappings does still appear to make a difference
>   for memory containing the kernel code, so allocator changes should
>   focus on code allocations — improving the layout of allocations for
>   loadable modules, for example, or allowing vmalloc() to allocate huge
>   pages for code. But, for kernel-data allocations, direct-map
>   fragmentation simply appears to not be worth worrying about."
> 
> So at the very least, if we went down this path, we would be worth
> investigating the following areas in addition to general perf testing:
> 
>   1) Only splitting directmap regions corresponding to kernel-allocatable
>      *data* (hopefully that's even feasible...)
>   2) Potentially deferring the split until an SNP guest is actually
>      run, so there isn't any impact just from having SNP enabled (though
>      you still take a hit from RMP checks in that case so maybe it's not
>      worthwhile, but that itself has been noted as a concern for users
>      so it would be nice to not make things even worse).

There's another potential area of investigation I forgot to mention that
doesn't involve pre-splitting the directmap. It makes use of the fact
that the kernel should never be accessing a 2MB mapping that overlaps with
private guest memory if the backing PFN for the guest memory is a 2MB page.
Since there's no chance for overlap (well, maybe via a 1GB directmap entry,
but not as dramatic a change to force those to 2M), there's no need to
actually split the directmap entry in these cases since they won't
result in unexpected RMP faults.

So if pre-splitting the directmap ends up having too many downsides, then
there may still some potential for optimizing the current approach to a
fair degree.

-Mike

