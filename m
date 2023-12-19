Return-Path: <kvm+bounces-4871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51AE081924B
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 22:30:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D323C1F254A7
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 21:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D779F3A29B;
	Tue, 19 Dec 2023 21:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eIwhhi53"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCAB3B19B;
	Tue, 19 Dec 2023 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiCi4XkMWT+5Er6oE1zXuL2drNMkmXuPW/XCPfDn3YY0bEugpLr+ufJVq4biczTGI7fzHS4NykjqvYT1WaGG1DLZIYkOQsMC5Asr1ZEz1zOjKWKhtHmdSv0ZY6/xYB5fzhGCnKyULlGxTzU+b1O9P3iC09hLJ6qaXzuVqNKW6n/JEHqslLKdHzUZXzfC5iqrLUwb87pcE34Xq++kSpQ3DpWPebbZvIIHjO++wgJhiK8YFX4MCzVqJbGh+Z/o07DyQI4Oay5fbZdKwj3PRDjVvrEyO92mZqsuu77IIIdbr/8ClkPBB6Vn4veYXPt1kRL2ndWNWNsb+ktp4D0tcKIhyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njFvsXpZeG4CEd1iTX4RH5PXIlbdu6OVa/YxjLvGJ8E=;
 b=I77ObClNyDWOUL9iWVmZN3lB37NnGfQIw/CGS5lOrL+XLMEXK4WKDcfMZyTu1CTHv2LC7Ug0nikBaUWoLSBplM0xnzBuepNYem3ZbyRfoHpp+ZTm53MU79uNO9CQCCF2Jva6G8bBQBFofaKeMFICaPq68ZRHIsNKFzJHo0kbSisYhxnqr/h/SGDzbT/CHv3hb3VUIjsvXBKqgVNdQZmp7Y+QWn2zQPBxoTYaKMecOlr7oRg6nHSBJIiWmi3dgdii0skw3Jh5DlSi90/n4vJac64kZ2YxWQtcmZAQvIGer3+7PCmvRcF92V6yt2casIzN4XGJ0QMg2LBTRJcxftVMEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njFvsXpZeG4CEd1iTX4RH5PXIlbdu6OVa/YxjLvGJ8E=;
 b=eIwhhi53xxA8QRrkIgEcmndumqpAYa9Xr3R1jb2c/J+7AWZqSKaG4q7FhahOjb8dWNc4kP0D40suhY+V6E+4/qg+UQObACK9TuT8IMol0CoUFJaFZzAyx46uC3KwyavOndjjBawPJGwdyh7LqkjYY0ttXA4fbQtpkcnnt5a4uJU=
Received: from SA1PR04CA0023.namprd04.prod.outlook.com (2603:10b6:806:2ce::27)
 by SN7PR12MB8148.namprd12.prod.outlook.com (2603:10b6:806:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 21:30:10 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:806:2ce:cafe::b9) by SA1PR04CA0023.outlook.office365.com
 (2603:10b6:806:2ce::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 21:30:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 21:30:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 19 Dec
 2023 15:30:07 -0600
Date: Tue, 19 Dec 2023 00:08:08 -0600
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
Subject: Re: [PATCH v10 08/50] x86/fault: Add helper for dumping RMP entries
Message-ID: <20231219060808.fngnt4lsvvqlnduu@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-9-michael.roth@amd.com>
 <20231115160852.GDZVTtFHB0+HpVZnpG@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231115160852.GDZVTtFHB0+HpVZnpG@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|SN7PR12MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: ab501e39-a1af-41b4-f78b-08dc00d9ad41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PT5xUKAjrU53mb1PZNQ/dFCNAPUc3cInuZUDhdg8kijQop/D0dGGsU2t6ZUuvU8WI1teA+7SEgbzJBvXj+7VBvOmkhRF4Q/iwAdy3+G3mF3v+KXnA71aphXh+ZfISeDIUMeDvAkPnTa0LShQDiSqVxbTe3NCtkflxUeT/c+iGGSXg1BiboNZaRdqSP199tdbhmcDndcoj599bsNdlnQDNzDCg0LaTaz7YXFVpUx+67QX0VCSFRaM7iR3s/bsyXTpf+bm09D0HBBbn5tbGmqfKTgYj4FVdp/zap8KghYM0lyaxjl4zSNYigYEXq0UK/qF2IAy+8eiYgPkD1/ZP+t+0rlk952i1itRAEy5oHePPw9Gc9xeVQZmzLe4A1NDJqcju/HCM5/cnc6g6zmOjQd9fp+Tw10GHjRbym71r3m0F7KyJzfxBzhKiqHvvsFVgWNPCIr6j53zaPRRjnGoxOtzOyqwamcQ+7tZk49eiA5zthJt75DFTuVtgFhEjw8DeCxHFD98FOhC2ZT3QXLZ4cWsa/vEvgDFLvw+I4L+eCmAEZHEaasmXuP5V7nw5ksp7uW1ErUlFGvkHZI97pvogv45NbGnYUHAReL3D/ZM+w5PuVsQtb2yt5/KJUbRr/hRkEeLHaTMMtsDaYBM6LJYXfskHV+iTcBh6/F9X/f7XwYYLATOaM2igf/jBn7P8PM++9NxmKrovokRHhaKHLlHns95FhrazPd2MTx8Tn2LaD9X8QGj0CWuO7HTgEQBn6I8TOlTpfJmans2sns9xBmR0zAUnQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(136003)(346002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(82310400011)(36840700001)(40470700004)(46966006)(36860700001)(356005)(40480700001)(47076005)(40460700003)(336012)(1076003)(426003)(83380400001)(16526019)(26005)(2616005)(36756003)(86362001)(82740400003)(81166007)(44832011)(478600001)(316002)(966005)(54906003)(6916009)(70206006)(70586007)(7416002)(4326008)(8676002)(8936002)(7406005)(5660300002)(2906002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 21:30:09.3827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab501e39-a1af-41b4-f78b-08dc00d9ad41
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8148

On Wed, Nov 15, 2023 at 05:08:52PM +0100, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:37AM -0500, Michael Roth wrote:
> > +/*
> > + * Dump the raw RMP entry for a particular PFN. These bits are documented in the
> > + * PPR for a particular CPU model and provide useful information about how a
> > + * particular PFN is being utilized by the kernel/firmware at the time certain
> > + * unexpected events occur, such as RMP faults.
> > + */
> > +static void sev_dump_rmpentry(u64 dumped_pfn)
> 
> Just "dump_rmentry"
> 
> s/dumped_pfn/pfn/g
> 
> > +	struct rmpentry e;
> > +	u64 pfn, pfn_end;
> > +	int level, ret;
> > +	u64 *e_data;
> > +
> > +	ret = __snp_lookup_rmpentry(dumped_pfn, &e, &level);
> > +	if (ret) {
> > +		pr_info("Failed to read RMP entry for PFN 0x%llx, error %d\n",
> > +			dumped_pfn, ret);
> > +		return;
> > +	}
> > +
> > +	e_data = (u64 *)&e;
> > +	if (e.assigned) {
> > +		pr_info("RMP entry for PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> > +			dumped_pfn, e_data[1], e_data[0]);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * If the RMP entry for a particular PFN is not in an assigned state,
> > +	 * then it is sometimes useful to get an idea of whether or not any RMP
> > +	 * entries for other PFNs within the same 2MB region are assigned, since
> > +	 * those too can affect the ability to access a particular PFN in
> > +	 * certain situations, such as when the PFN is being accessed via a 2MB
> > +	 * mapping in the host page table.
> > +	 */
> > +	pfn = ALIGN(dumped_pfn, PTRS_PER_PMD);
> > +	pfn_end = pfn + PTRS_PER_PMD;
> > +
> > +	while (pfn < pfn_end) {
> > +		ret = __snp_lookup_rmpentry(pfn, &e, &level);
> > +		if (ret) {
> > +			pr_info_ratelimited("Failed to read RMP entry for PFN 0x%llx\n", pfn);
> 
> Why ratelmited?

Dave had some concerns about potentially printing out ~512 messages
for a particular PFN dump, and this seemed like a potential case where
that might still occur if there was some issue with RMP table access.
But I still wanted to print some indicator if we did hit that case,
since it might be related to whatever caused the dump to get triggered.

> 
> No need to print anything if you fail to read it - simply dump the range
> [pfn, pfn_end], _data[0], e_data[1] exactly *once* before the loop and
> inside the loop dump only the ones you can lookup...

Similar to above, the loop used to print every populated entry in the
2M range if the dumped PFN wasn't itself in an assigned state, but Dave
had some concerns about flooding. So now the loop only prints 1
populated entry to provide some indication that there are entries
present that could explain things like RMP faults for the PFN that caused
the dump.

That makes it a bit awkward to print a header statement, since you end
up with something like:

 PFN is not assigned, so dumping the first populated RMP entry found with the 2MB range (if any)
 PFN_x is populated, contents [high=... low=...]

Or if nothing found:

 PFN is not assigned, so dumping the first populated RMP entry found with the 2MB range (if any)

Whereas the current logic just prints 1 self-contained statement which
fully explains each of the above cases and doesn't require the user to
infer there was nothing present in the range based on the lack of
statement. It's a little clearer, a little less verbose, and a little easier
to grep for either situation without needed to get context from surrounding
statements.

> 
> > +			pfn++;
> > +			continue;
> > +		}
> > +
> > +		if (e_data[0] || e_data[1]) {
> > +			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> > +				dumped_pfn, pfn, e_data[1], e_data[0]);
> > +			return;
> > +		}
> > +		pfn++;
> > +	}
> > +
> > +	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
> > +		dumped_pfn);
> 
> ... and then you don't need this one either.
> 
> > +}
> > +
> > +void sev_dump_hva_rmpentry(unsigned long hva)
> > +{
> > +	unsigned int level;
> > +	pgd_t *pgd;
> > +	pte_t *pte;
> > +
> > +	pgd = __va(read_cr3_pa());
> > +	pgd += pgd_index(hva);
> > +	pte = lookup_address_in_pgd(pgd, hva, &level);
> 
> If this is using the current CR3, why aren't you simply using
> lookup_address() here without the need to read pgd?
> 
> > +
> > +	if (pte) {
> 
> 	if (!pte)
> 
> Doh.

Yikes. Thanks for the catch.

> 
> > +		pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
> > +		return;
> > +	}
> > +
> > +	sev_dump_rmpentry(pte_pfn(*pte));
> > +}
> > +EXPORT_SYMBOL_GPL(sev_dump_hva_rmpentry);
> 
> Who's going to use this, kvm?

This is mainly used by the host #PF handler via show_fault_oops(). It
can happen both for kernel or userspace accesses if there's a bug, so
that's why the read_cr3_pa() is needed, since these may be userspace
HVAs. Though I just realized the patch that uses this (next one in the
series) claims to only be for kernel #PFs, so that might cause some
confusion. I'll get that commit message fixed up.

Thanks,

Mike

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

