Return-Path: <kvm+bounces-4872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6334681924E
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 22:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ACD1287B84
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 21:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472F13B19B;
	Tue, 19 Dec 2023 21:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BoNuw3Rw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2343D0C2;
	Tue, 19 Dec 2023 21:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7GRe3G8MQPSyK1Q2+UXrrtzl0UH7S9v4KqL4S0TLit9WCVe0P+2OPQMGWnZn9g/5xe8Ee3VZA4rPtaYMkCoHKWIAtJVZn5aZnXBLc325hgogY+lWlYcdfmP0e2dCcBg6eaY+PPmNGDL3mK8r7wPeZ8HhRL93bucHhlaSxhb4wa9r94fnMIjy3f4ankIju3dOrgLRnd+G4cuM/bczSJJUePcs7r/v6UcSRIl8aTR1UjRm7wBb1BDXRh6hOlglWzh9jmX0ZlUzKX/w1uv4RhetkNHJIvpHJzXVDizXMzKD2wEOpmtcbc1eYma9GtYss1NafoeeEjLzg9vz5l6+PKq+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06d69L1CrHqIxaTmS38aZSzitC0So0NOlv1zMifyYxc=;
 b=I25/BA9MJsfXeOzfMTO5MdEXkC6iyMQnlruw3CrbkickLUAXxLiJAcPnWv330te3rqRtJiptef/u9qXsICW/o8n5sOUbWAJ6j+V287OzpwgIyPwmrDVW1ADhN5BK+mvjKzSmboSkTPA5jhn1ECgWhVOF86mkf6UExcRKCA4urHZqAZ4PnBb+l/++b1TdfeNMgdfpWDBTAsn/GRKs1+mPTQVhDI51oC0wBw1CFAIaQa5TpqdbvULZluEd7u8SEK5ODq2AU+cTQ8oQYFdDEmsvFsww8GF7jaxbOVCnkWsLONw8T4wCKvKZS2OW/7UP+ldzusp45SxfziROw9dCunopig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06d69L1CrHqIxaTmS38aZSzitC0So0NOlv1zMifyYxc=;
 b=BoNuw3Rw/v1xSYYS7gpkwirFUt8KxAU5A7iL1nqfozt/0meFRI5JX0svCF9cdiTCokkofbgkOhcRU76U5Jl5pXdB0hTXWbivfh4xOPOKeRQPgZ9E2uTqkUr5ImgjFmL39ZOSMLZqLdDtiPPfkXquTrWs1JLtGcg3LV7QK6c2ZdU=
Received: from CH2PR05CA0009.namprd05.prod.outlook.com (2603:10b6:610::22) by
 LV3PR12MB9165.namprd12.prod.outlook.com (2603:10b6:408:19f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 21:30:32 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::c3) by CH2PR05CA0009.outlook.office365.com
 (2603:10b6:610::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 21:30:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 21:30:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 19 Dec
 2023 15:30:28 -0600
Date: Tue, 19 Dec 2023 10:20:26 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
	<tony.luck@intel.com>, <marcorr@google.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 11/50] x86/sev: Add helper functions for RMPUPDATE
 and PSMASH instruction
Message-ID: <20231219162026.mzicb22hbwjycpzg@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-12-michael.roth@amd.com>
 <20231121162149.GFZVzZHQB1g2bdvJie@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231121162149.GFZVzZHQB1g2bdvJie@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|LV3PR12MB9165:EE_
X-MS-Office365-Filtering-Correlation-Id: 9566ee79-2ea1-4314-6780-08dc00d9b95b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wdnBtnFz5dQcEiFh4uyCOjtN5ZK9tmGjkrYM1LKZcW/X6t7Yn5xHnZT+hF3EwiLMNK5u4fxlxEHb38MFkHVov55qF9uLrwXugYzyWlK149V/bP//ajSdBKdfYfkkxittkViE3BckygfWGgfYOTregBQOAnr9ozGy7FLGjU77RRMgv8j7qyWpOuNzC44LLAYeQapmF2oE9rmZ7mdwaXBjUTLIpWZf6w+2oLegHGF8YMNx4jvfLr8dzhyj735oAgLAd8ziMJGxIY6wF6l3WzJtr6kEwweyxedhPdzBdSNqXRoKG2MULPWESNmdo46SQyKDe3wbn/CgPODhBNJ9rlmasz5AjFqVr014ZjUvyv7s3gaXgnBqmUlnQhTk7k2DoD9vPez4AXE0TmlzO/Acor7veFp1xkfIqcuvNe/ilZAWkqBVSuZ+I3iYOYqUYyHm02taexSwmYEwecwzjYC5Lo2z6JPcStEURjqIAcEZxHnToOyte6Vkmxugeoi21cSB1FgaNTalOm0TOorFYL9ios4L/xPYmXF017Tr0KORnXpRgcDDIyNrG0gJunFn1h56eyBvA7wYiXGMvawzHzM83529pQIYFazH9JZl1qt7NbqG/ObFLYnh3emVegrdatyVD+rbqnESU//JoqL9DpPr3PnHei5xDiDA4t1fMPn0LddusbBdlLcVvDAZGsAiAHg3a0SKD2I19JylbkLVvgrjLWBMRPtGYB07/f/GtPVvWuKLfv+Z7gnEj3Cdc5VARDbYlqPYNIgkvHsDF2qDux6Yp89rDg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(136003)(396003)(230922051799003)(82310400011)(64100799003)(186009)(1800799012)(451199024)(40470700004)(46966006)(36840700001)(8936002)(5660300002)(36860700001)(44832011)(47076005)(4326008)(8676002)(2906002)(83380400001)(6916009)(316002)(426003)(70586007)(40480700001)(70206006)(7406005)(7416002)(336012)(54906003)(41300700001)(82740400003)(40460700003)(81166007)(356005)(26005)(16526019)(1076003)(966005)(86362001)(2616005)(478600001)(36756003)(66899024)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 21:30:29.6352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9566ee79-2ea1-4314-6780-08dc00d9b95b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9165

On Tue, Nov 21, 2023 at 05:21:49PM +0100, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:40AM -0500, Michael Roth wrote:
> > +static int rmpupdate(u64 pfn, struct rmp_state *val)
> 
> rmp_state *state
> 
> so that it is clear what this is.
> 
> > +{
> > +	unsigned long paddr = pfn << PAGE_SHIFT;
> > +	int ret, level, npages;
> > +	int attempts = 0;
> > +
> > +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> > +		return -ENXIO;
> > +
> > +	do {
> > +		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> > +		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> > +			     : "=a"(ret)
> > +			     : "a"(paddr), "c"((unsigned long)val)
> 
> Add an empty space between the " and the (
> 
> > +			     : "memory", "cc");
> > +
> > +		attempts++;
> > +	} while (ret == RMPUPDATE_FAIL_OVERLAP);
> 
> What's the logic here? Loop as long as it says "overlap"?
> 
> How "transient" is that overlapping condition?
> 
> What's the upper limit of that loop?
> 
> This loop should check a generously chosen upper limit of attempts and
> then break if that limit is reached.

We've raised similar questions to David Kaplan and discussed this to a
fair degree.

The transient condition here is due to firmware locking the 2MB-aligned
RMP entry for the range to handle atomic updates. There is no upper bound
on retries or the amount of time spent, but it is always transient since
multiple hypervisor implementations now depend on this and any deviation
from this assurance would constitute a firmware regression.

A good torture test for this path is lots of 4K-only guests doing
concurrent boot/shutdowns in a tight loop. With week-long runs the
longest delay seen was on the order of 100ns, but there's no real 
correlation between time spent and number of retries, sometimes
100ns delays only involve 1 retry, sometimes much smaller time delays
involve hundreds of retries, and it all depends on what firmware is
doing, so there's no way to infer a safe retry limit based on that
data.

All that said, there are unfortunately other conditions that can
trigger non-transient RMPUPDATE_FAIL_OVERLAP failures, and these will
result in an infinite loop. Those are the result of host misbehavior
however, like trying to set up 2MB private RMP entries when there are
already private 4K entries in the range. Ideally these would be separate
error codes, but even if that were changed in firmware we'd still need
code to support older firmwares that don't disambiguate so not sure this
situation can be improved much.

> 
> > +	if (ret) {
> > +		pr_err("RMPUPDATE failed after %d attempts, ret: %d, pfn: %llx, npages: %d, level: %d\n",
> > +		       attempts, ret, pfn, npages, level);
> 
> You're dumping here uninitialized stack variables npages and level.
> Looks like leftover from some prior version of this function.

Yah, I'll clean this up. I think logging the attempts probably doesn't
have much use anymore either.

> 
> > +		sev_dump_rmpentry(pfn);
> > +		dump_stack();
> 
> This is going to become real noisy on a huge machine with a lot of SNP
> guests.

Since the transient case will eventually resolve to ret==0, we will only
get here on a kernel oops sort of condition where a stack dump seems
appropriate. rmpupdate() shouldn't error during normal operation, and if
it ever does it will likely be a fatal situation where those stack dumps
will be useful.

Thanks,

Mike

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

