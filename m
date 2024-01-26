Return-Path: <kvm+bounces-7042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D852083D250
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 02:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 901D528DCA9
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 01:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B22567D;
	Fri, 26 Jan 2024 01:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p7yNv7DK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4768F6D;
	Fri, 26 Jan 2024 01:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706234361; cv=fail; b=hlg1jw+ewGsF76lWaVCvOST5sQviCBSCfn0WPuXYviIEWIjTY1f41UG1wASFl/VziDyekKBarb9bKAC3rFBMcFzbyxopsy4sjiWuMKASfu5BEyPZRlWjh25RpICy7HPIWLX4vVajzJFBg5g4zFTyb1lv988ZTvOG66h80ZzYXyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706234361; c=relaxed/simple;
	bh=OWRznW6ZZ7xmwSIqhjzDuiUI4OB88o7DM/OJvogATEE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nAO8l9Nc2DMj7ivA5xvjfMvvFe/dIl6P2MDKUImvV5zU8ooGIpaTOzsL6QqHBhWZibUtXL8bCMxefar6o2Y0/zDow5CC3pCkY88GpVsJEjVrb+dRSw4vcw37YicS7JvNnFKSmZLslJZflTQZIJQiEq22CoGFHPB8t9s07aq6X8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p7yNv7DK; arc=fail smtp.client-ip=40.107.220.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpiNHhBiUCocQXcuMCOf2DmybnkhBTiWZa5vMY5fdwYmbkUI4yWdJHTovpLyRnYCvChTBMm/tzCuxw49ZjEn75e54pl1Jl54A2tbQsO39Jktf94Il6sIHhCcf/U14YvrYEf1TgogeCGL9aQyHYhfhocDFottD633GQfb8ZGcFIe4SvpCm0Ta/oL/lwSYu9MljrmsjFTlvG3hwdOvBYNQ3peGoBvvBL6aMqJMsjgaQQlOXwUamVRDWA00YsBivq5u/gGTxhACzK/YqySYhvtQf/PbkMJ0tBoZliuON5Nxscbu5eSha1oBz9FMZ+EbYg8LPG17UKzYfm9g2+T56w1n7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VgPQWdYIWye7gSd5T4XU3AlTAyJpqFd0DJrapNBGGg=;
 b=XWYITXKTf19Ya5X+IyoINbqF9TS4WuoKY+Tz1LWF+JU7+bV+F2hnE6dw7svDILDac12hFvBxpaSn9MxllgAuHUUuPHhBCpmra1ZH8QAC18NpoRv+a6iyOg5jKto6voic67tasevLIHp7U+4jbo+F9tRLpD0VvkL0T+5KJbM9h60D28bkJhLqgdp6pPXPDpJ+adm51QMMxpMVXbQMoFgCwdybDF6OFFL3w/jVaP98iaz4hUyB0Ogb1Qe3Brk57Yflbsvw2BpDc6YzB4qpC79fg+ZzMooMygK6asSx5TnsYY5xwYk0pml+iE8Dt1DgewPQLLTVNg+KQWdNum+/rWAOEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VgPQWdYIWye7gSd5T4XU3AlTAyJpqFd0DJrapNBGGg=;
 b=p7yNv7DK33q9wUkZQsDI7qBflfdmoFWpp2cK7cdo/fvrbRNFBBeD2RrpIX/yPlaJ9EWLpnB+vpfqVdZKeL0wNFD6zDHRCAf0JscXlxF6a4qFz7vwc8uYmWt4EuqW7rEGRuo9Oy2bHIEfPF2/fF4MUFHqbgLPKkxxB36QYHjY+fw=
Received: from SA1P222CA0039.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::12)
 by MW4PR12MB6731.namprd12.prod.outlook.com (2603:10b6:303:1eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 01:59:18 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:2d0:cafe::25) by SA1P222CA0039.outlook.office365.com
 (2603:10b6:806:2d0::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 01:59:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 01:59:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 19:59:16 -0600
Date: Thu, 25 Jan 2024 19:49:35 -0600
From: Michael Roth <michael.roth@amd.com>
To: Mike Rapoport <rppt@kernel.org>
CC: Dave Hansen <dave.hansen@intel.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240126014935.m6yhr2jv2r4kfenc@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <63297d29-bb24-ac5e-0b47-35e22bb1a2f8@amd.com>
 <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
 <20240116161909.msbdwiyux7wsxw2i@amd.com>
 <20240116165025.g4iouboabyxkn5nd@amd.com>
 <ZabjKpCqx9np0SEI@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZabjKpCqx9np0SEI@kernel.org>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|MW4PR12MB6731:EE_
X-MS-Office365-Filtering-Correlation-Id: af8766f7-f650-4e22-12e6-08dc1e126776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iYSk4kPNlp7wBZ/m+3IC+zP3Atd+VXlFhdQURCzgj3ruX20weEkJbjXkJbduUqciwKYWrBI5RG9f+dP97bmy22ZMxLmqC8v4v1heRBX8dH2qkiR82vE32q+AkDmrMpHuy+VSbREFXfzHkHgp4RpsSsdtb84agYvwrtbIibJvygcOxGwWp9Dd0g+C/jANIlQTjL0zH8uFzLSvA2481+fLPThgE4sxclFhIGpTjcqR4qXfCi5Q1ujqbJcpWQqpNYjPmVhe6WjzHX1ICOtg1328Hf7VGLqWs+h4AI6gwcL2LO6SbptxsBNb9MQScwYL3kCJ/5KLWwbtmN4U56h+I8xUoHhIj13Zo4A766bDOFuRS+tN5vXgvHrMpvI8iC8/8BdsITW6N8pJUyWwBq3z5el6n0+9ytDjFWvz/LwKe6OBBhFNWkdykMJXSMQV4KVEeI3jkaLHgjT3slOtTCCVtxtqw9B17SysnihmGH5+WCGB05eK3zbKNaXjioOUVdAeUr7plPXvKSwAbCPbz0o5uQuqoOARYCfMCWvusy4ZEJMt2smxEiEpoYcStIjCWd/dXQmahNZBCdtewkVTNJlGMX8/u+/B0/5LQJPyLjolQykwZYpjWX7K3E9FBjlRb8q0VOFAL5QK4wzDjrjB9c4cAW5z98TJqR5f6v7bMSVkwkU9nWg6LHrOez+fEme0E6ZuK24gZ/y8Qa1UgHXZ0AUOqSo4nAYQjLyLw3AXlxpvb/F4d9x+d3FNPAfOKV6nPRlXctkDiBbZGgz8a0xri902onnwMA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(82310400011)(40470700004)(46966006)(36840700001)(16526019)(26005)(336012)(426003)(2616005)(1076003)(41300700001)(478600001)(6666004)(83380400001)(5660300002)(36860700001)(86362001)(70206006)(70586007)(6916009)(316002)(54906003)(36756003)(40480700001)(356005)(44832011)(40460700003)(82740400003)(8936002)(4326008)(7406005)(47076005)(8676002)(7416002)(81166007)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 01:59:17.3178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af8766f7-f650-4e22-12e6-08dc1e126776
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6731

On Tue, Jan 16, 2024 at 10:12:26PM +0200, Mike Rapoport wrote:
> On Tue, Jan 16, 2024 at 10:50:25AM -0600, Michael Roth wrote:
> > On Tue, Jan 16, 2024 at 10:19:09AM -0600, Michael Roth wrote:
> > > 
> > > The downside of course is potential impact for non-SNP workloads
> > > resulting from splitting the directmap. Mike Rapoport's numbers make
> > > me feel a little better about it, but I don't think they apply directly
> > > to the notion of splitting the entire directmap. It's Even he LWN article
> > > summarizes:
> 
> When I ran the tests, I had the entire direct map forced to 4k or 2M pages.
> There is indeed some impact and some tests suffer more than others but
> there were also runs that benefit from smaller page size in the direct map,
> at least if I remember correctly the results Intel folks posted a while
> ago.

I see, thanks for clarifying. Certainly helps to have this data if someone
ends up wanting to investigate pre-splitting directmap to optimize SNP
use-cases in the future. Still feel more comfortable introducing this as an
optional tuneable though; can't help but worry about that *1* workload that
somehow suffers perf regression and has us frantically re-working SNP
implementation if we were to start off with making 4k directmap a requirement.

>  
> > >   "The conclusion from all of this, Rapoport continued, was that
> > >   direct-map fragmentation just does not matter — for data access, at
> > >   least. Using huge-page mappings does still appear to make a difference
> > >   for memory containing the kernel code, so allocator changes should
> > >   focus on code allocations — improving the layout of allocations for
> > >   loadable modules, for example, or allowing vmalloc() to allocate huge
> > >   pages for code. But, for kernel-data allocations, direct-map
> > >   fragmentation simply appears to not be worth worrying about."
> > > 
> > > So at the very least, if we went down this path, we would be worth
> > > investigating the following areas in addition to general perf testing:
> > > 
> > >   1) Only splitting directmap regions corresponding to kernel-allocatable
> > >      *data* (hopefully that's even feasible...)
> 
> Forcing the direct map to 4k pages does not affect the kernel text
> mappings, they are created separately and they are not the part of the
> kernel mapping of the physical memory.
> Well, except the modules, but they are mapped with 4k pages anyway.

Thanks!

-Mike

> 
> > -Mike
> 
> -- 
> Sincerely yours,
> Mike.

