Return-Path: <kvm+bounces-7259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A0A83E749
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:54:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C77881C26439
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE1059B43;
	Fri, 26 Jan 2024 23:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fWCT+5NF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4F020320;
	Fri, 26 Jan 2024 23:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706313286; cv=fail; b=gII+d9MV5bFdUIiNZfNzU9d/pXmQSXB25ZiX6SmbfUXta6tixeYiIbOHY7avU4T84a6XoTUL+ZX8eAeg7zOxhrTlNHXICzCCw3x0dJAvgLMfbpqdCpHmC2EPDBSiGw+L+2Lm+MQrLaKUJUCS7toW4Xg5+7Eo/I9n1hH8ZOqerz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706313286; c=relaxed/simple;
	bh=FfXZ7x2qGBN6QehgouhexwIqD6sLQo+74Q3G27bEsTc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abITHQ3iX3f6dvRaQK0ij8FndV5w5XVyeNv+4QMm0vc1AzB04vRX+lszuA8VsFQIjgE0D+a4HZSGe4tQbMHqkVIkIxIQh6hVZZaBSFVDPAWKWRb1IqIFRoJvWPnhb1ntLXgmgDk2t9GloTn3YMXbyDLzEPbsdoGCVMFlWbkObPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fWCT+5NF; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAEB7IbA8od+QWRFUnegmUaJvRgXlG3uGvg9oqRCA3o9r6251LknZZ6GIaWhk+SSnO3H52OrkwNtCQAiGgM1ts9WHhBYvX3FNruyz6yY9aVTdeYTBTOKgRVtrKixEQsh5ztB6PgqtNoHw+EpXDFOGG9aYev9p7bI8fGg/k7r+eSUXa+TetW1l6vxwS3ArpT5mOralmxmlIS/AorQzj1N9mpIB0lysyjHYd4Um0+uJh9ahWBfJVeMarhpuMkkoh3yffq4vE3nY2W5H805mxhuneqS1nwgWAT2vOSsRGGQOoDt2kKPYlr2NoUHFeyVhk76kBVXjk14Q7y9d68bjBG2nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wHnL7u6s8sdvRMf3uic4a10KJS12/oeCxM4Jt6Mlow=;
 b=f/ymHpNOmZV2SYa72kDMiDDMqalftV1BI2wNVU8264F13Nyx1yRshlf/b3142icIsrEeWwVTzf9mfXa8B4QJ/0wW+Tt3auda65fC6ruoRF/xnil+WTMCcdQ7sw20EQDLPME0KkOdcffHVJnLuYNy6GSjUzOGtMYRVqK8daZxq82CwjKXJWjf35Dx+IzYUCZhO2raaYUyCkdXZC/ulyw0DlimEcn+BzxM/Ts0Ay/EXq1F2sbBiJd4x1iaofs7ObMCxMo7uGUbKOTBWGB8mb1AQ78sFJcylvdlJnstpdsfqeSZQXnp3KYdz8GnPIEoKJqSiTIfE2qJMVkAi6j4IWC/DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wHnL7u6s8sdvRMf3uic4a10KJS12/oeCxM4Jt6Mlow=;
 b=fWCT+5NFCRZxAbc1dXG2dWeCnqMpY9V4VOf2S55pNBtWnSrx6CN5rjOzsjgVjzw9vwY44oEtQHF6sgNJWjToC+sOvBnbah1WBjrp4+THiRvB8v1twvTX28QgWqksqZcn+vFkiUVeVcUqQDJC5pIoJlFgovCB4rq1CLeMkrR5dbc=
Received: from BLAPR03CA0133.namprd03.prod.outlook.com (2603:10b6:208:32e::18)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 23:54:40 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::c7) by BLAPR03CA0133.outlook.office365.com
 (2603:10b6:208:32e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 23:54:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 23:54:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Fri, 26 Jan
 2024 17:54:39 -0600
Date: Fri, 26 Jan 2024 17:54:20 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 11/25] x86/sev: Adjust directmap to avoid inadvertant
 RMP faults
Message-ID: <20240126235420.mu644waj2eyoxqx6@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
 <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
 <20240126170415.f7r4nvsrzgpzcrzv@amd.com>
 <20240126184340.GEZbP9XA13X91-eybA@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240126184340.GEZbP9XA13X91-eybA@fat_crate.local>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e2cd9f6-4175-416d-6f6d-08dc1eca2908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sizMSvqj3rx8isC8yIg+s2E9ftCsbPqpTYW776SFVypLuAcyo+vc5D0cQeYnFwdwdgmWQKfTX4mL6oHmg4jdoSEHubdV6ivh2EN6MaLRVd8MNIBLj6PfYWj+CzHivy2BrYYcXbOnNlfmg/eS1o7N7TSpUb/2iEFSApKk7ovSQksE293fjM5uNmoGEOfofzE4BQ7gIfetNwFvrJin8t7cxO8+DSuwSfnKDtjFY1+edqOjBtqXn1Yxfn9jlj1okdRuCes9Lq0cBo8DuIlURR5iwOJoUIGXYjomSj5jfFB0zYAafkxj8mCaqC+gSejI5zBLX/okDBqLayu5fnUia8tGzRzDk/OtLew+D07CY+C7xci45hfnE9VFs/RUGF2eWq++HNB0G7xn7vfQUqQWi8LSSY4O8rMN9MzH1jtcvPSNNneMpwviqxnjEkSg4JeLBouuMSICQKxOlOWnVWH8Rtwlqf8rbLHcDDU/oiHLK7AuaAW33IvxSuTQKq288zhbhYZsxqaHiDR6egtuqqwCK4W1tspsvbLiJ2X210M9brpF7RVOGpqZxXFhv48TZCewYvPJSU28bzzL98J1y7KcoFdTCexVnt3yFSOKRjkaDYUM3w2XRuaTxXDByW+01fVbO+bfuzFqWi2Z56OMBvPDOyRpmalvcsCvB++xEdaNnl8MpiYImC3BBryKTBf2zP4QGLW8Au+x4k/9xhLb8Y5ckGUPXrPgPRD6wItBOlRGhtaYI4aEUN7avtkG7IjgjEd5uNAC
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(82310400011)(186009)(64100799003)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(54906003)(6916009)(1076003)(70206006)(70586007)(316002)(40460700003)(40480700001)(5660300002)(2616005)(426003)(336012)(478600001)(6666004)(16526019)(26005)(966005)(36756003)(83380400001)(66899024)(44832011)(41300700001)(81166007)(2906002)(356005)(86362001)(47076005)(8936002)(8676002)(36860700001)(4326008)(82740400003)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 23:54:39.9632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2cd9f6-4175-416d-6f6d-08dc1eca2908
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577

On Fri, Jan 26, 2024 at 07:43:40PM +0100, Borislav Petkov wrote:
> On Fri, Jan 26, 2024 at 11:04:15AM -0600, Michael Roth wrote:
> > vaddr comes from pfn_to_kaddr(pfn), i.e. __va(paddr), so it will
> > necessarily be a direct-mapped address above __PAGE_OFFSET.
> 
> Ah, true.
> 
> > For upper-end, a pfn_valid(pfn) check might suffice, since only a valid
> > PFN would have a possibly-valid mapping wthin the directmap range.
> 
> Looking at it, yap, that could be a sensible thing to check.
> 
> > These are PFNs that are owned/allocated-to the caller. Due to the nature
> > of the directmap it's possible non-owners would write to a mapping that
> > overlaps, but vmalloc()/etc. would not create mappings for any pages that
> > were not specifically part of an allocation that belongs to the caller,
> > so I don't see where there's any chance for an overlap there. And the caller
> > of these functions would not be adjusting directmap for PFNs that might be
> > mapped into other kernel address ranges like kernel-text/etc unless the
> > caller was specifically making SNP-aware adjustments to those ranges, in
> > which case it would be responsible for making those other adjustments,
> > or implementing the necessary helpers/etc.
> 
> Why does any of that matter?
> 
> If you can make this helper as generic as possible now, why don't you?

In this case, it would make it more difficult to handle things
efficiently and implement proper bounds-checking/etc. For instance, if
the caller *knows* they are doing something different like splitting a
kernel-text mapping, then we could implement proper bounds-checking
based on expected ranges, and implement any special handling associated
with that use-case, and capture that in a nice/understandable
adjust_kernel_text_mapping() helper. Or maybe if these are adjustments
for non-static/non-linear mappings, it makes more sense to be given an
HVA rather than PFN, etc., since we might not have any sort of reverse-map
structure/function than can be used to do the PFN->HVA lookups efficiently.

It's just a lot to guess at. And just the directmap splitting itself has
been the source of so much discussion, investigation, re-work, benchmarking,
etc., that it hints that implementing similar handling for other use-cases
really needs to have a clear and necessary purpose and set of requirements 
hat can be evaluated/tested before enabling them and reasonably expecting
them to work as expected.

> 
> > I'm not aware of such cases in the current code, and I don't think it makes
> > sense to attempt to try to handle them here generically until such a case
> > arises, since it will likely involve more specific requirements than what
> > we can anticipate from a theoretical/generic standpoint.
> 
> Then that's a different story. If it will likely involve more specific
> handling, then that function should deal with pfns for which it can DTRT
> and for others warn loudly so that the code gets fixed in time.
> 
> IOW, then it should check for the upper pfn of the direct map here and
> we have two, depending on the page sizes used...

Is something like this close to what you're thinking? I've re-tested with
SNP guests and it seems to work as expected.

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 846e9e53dff0..c09497487c08 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -421,7 +421,12 @@ static int adjust_direct_map(u64 pfn, int rmp_level)
        if (WARN_ON_ONCE(rmp_level > PG_LEVEL_2M))
                return -EINVAL;

-       if (WARN_ON_ONCE(rmp_level == PG_LEVEL_2M && !IS_ALIGNED(pfn, PTRS_PER_PMD)))
+       if (!pfn_valid(pfn))
+               return -EINVAL;
+
+       if (rmp_level == PG_LEVEL_2M &&
+           (!IS_ALIGNED(pfn, PTRS_PER_PMD) ||
+            !pfn_valid(pfn + PTRS_PER_PMD - 1)))
                return -EINVAL;

Note that I removed the WARN_ON_ONCE(), which I think was a bit overzealous
for this check. The one above it for rmp_level > PG_LEVEL_2M I think is more
warranted, since it returns error for a use-case that might in theory become
valid on future hardware, but would result in unecessary 1GB->2MB directmap
splitting if we were to try to implement handling for that before it's
actually needed (which may well be never).

-Mike

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

