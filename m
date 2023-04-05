Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62206D8B3F
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbjDEXsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjDEXsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:48:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97447695;
        Wed,  5 Apr 2023 16:48:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjWb60QM+mc+GWtfat4vXbeR7I+fAuAnXKzTwv6p2RTO8fzhYS/QxN1WMz3vPaFGLzp44LYizcljBeWirpEU72iUNr4GFh02ns4FrqlOUeTRMfeGhkvAw0hqeVjeT8sI1ASTg8XtJfXqUrWG91AWossqPTJjhnbN4thB6mQaxnIQomXTi9rR6EwyQ7/bnSOkdi9+Hxe3feBbYbSZlTslg6Zi+vT5SngM+bWXMF5Y6RsUXH8bjE2QiMNXxHi2t5ZOGvDZngyp2Zctlz/SZ7+wPFWQ/TrwuIIpeZOg45UkpsGQOTQkWTiwhbkFl8R4qQyxp4qaB6Fvysx23reeQGLuMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8ebVcd/2bOXLpPkp09qqS5sbtf8/fY71rqwKjQZaXE=;
 b=FSISSYnxQGbeljddeVy1Azw35fbTYA/rlBout9MPO37DfHNrO1lGPXTw6quC/DWzazqQgwitn0oMXzFGFnseIWz+T/Cnb5xRhuHSosw9IoBpljZ3S3TDH3kdm3jxbgc18piZr8HNnmYhz0symqtdr+rYbtp4XGTfqwhD0yt7E3HB34cBsvU2oCaQekfWQRnPdQXOXlZTE69ZlF2R2Vi+UasjL7KjEoy6UQuYyOAh3TqDTzljSIB1DRHwEUgKl6HtGaQvehJmWhQdfYdILOy0401pyrKajHux4nVCe1HAKu6RtI6w4VFcaHTfFnzIWuZPlHu5zHA1bTTrgMbWYUUwTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8ebVcd/2bOXLpPkp09qqS5sbtf8/fY71rqwKjQZaXE=;
 b=Fb/S8vITSLnS++7GHBbRcQLmdnLFW7Eeu1vbiUGHcwJdn/ZFGLlolwFbo02oZs291ubKl67qK3UOtXP/Uw9naUgV1Fbddxg/vX3CSBbm0pKL3dEGbIa64oBOtELegL5JJGdNI5cCYROFVbc9JkGMvzHqRJBp7i/IZ+8QsXja7jk=
Received: from BN0PR10CA0021.namprd10.prod.outlook.com (2603:10b6:408:143::24)
 by CH2PR12MB4152.namprd12.prod.outlook.com (2603:10b6:610:a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 23:48:49 +0000
Received: from BN8NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::33) by BN0PR10CA0021.outlook.office365.com
 (2603:10b6:408:143::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Wed, 5 Apr 2023 23:48:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT084.mail.protection.outlook.com (10.13.176.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.30 via Frontend Transport; Wed, 5 Apr 2023 23:48:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 5 Apr
 2023 18:48:46 -0500
Date:   Wed, 5 Apr 2023 18:48:26 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 48/56] KVM: SVM: Add SNP-specific handling for
 memory attribute updates
Message-ID: <20230405234826.adaxo5fws6icwngy@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-49-michael.roth@amd.com>
 <f664f44d-fc0a-1af7-070c-306ab100bbc9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f664f44d-fc0a-1af7-070c-306ab100bbc9@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT084:EE_|CH2PR12MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: f406b4a7-764a-40c5-4fbf-08db36304db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HvHpBlwzja9kOmDkOyCtdnIhn6oCjda6QMp/kx2ib12Vc8oRCFF6OLgqH18VP+52mOwE8pslf4qSa/TKBwEnsI/w99cqg7GEaHpcaDJPscurtIl7UKkwDU6wORB/ipVBCSLCfZ2veyzVbG7hdXZ9DbfYPIGH7RTthDk1Lw1QAGSuX95O+v+oA2NRNSmXgNdugKeNW8hLynA8SZg2qI77PbRI5S9VQ/aGqz7L0vzvNi7Cd9E5ku5FuWjMaN74NkEnm1tGdWYVYn8S5btWlgVkU6zRaNntuvjoYJsoVJNJ8vQ+N00jbfcKHVUb5lG0Fv5/x25UQ1okGV5MbtOxGazymkveQUdyFrx4bKkHOlZjlW/1wgkyAH5fIsJyZfq6WYiPPP+Lvk+xgZo8jNaxbufqWRyRP4CX3Hfy03FdK8w8Ynwy6raYuTUJCX7SRKX6JHCZGwl0SalY5hFuoCdMD57ihvu0Ryzq9htO4AqaJtZhBxnVaJfVS8mS+mC+uWdc+imHPS1CvsWbaQLrGNuhCiuXoaHeEO6ZhqOUnuDSZuMnNA3qWMfAgWTrGBFrFvxsCBCZTMsBX5FMy7cAgwxXWDXgvyO88ezUsDTwNsVvX/Td2R+piDYDLZk8R4r/pu9eMTZ8EMW4SQey0K08jyJzcJ9KDKc7FDnvOcehvt6CNQiba8wvNj5LtutVaQb52NkEQeJAvRT6xilScXW+2jQAYiOAxa5I0OFySQNXPdRjYtW9hnYCXXt7xWMHJAISnCD/N+3EJHfvsnrKkCjQUHFiqKgsOw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199021)(36840700001)(46966006)(40470700004)(1076003)(53546011)(26005)(16526019)(186003)(40460700003)(4326008)(478600001)(54906003)(36860700001)(82310400005)(316002)(966005)(7416002)(86362001)(7406005)(5660300002)(36756003)(8936002)(2906002)(82740400003)(44832011)(70206006)(6916009)(70586007)(8676002)(356005)(81166007)(41300700001)(15650500001)(40480700001)(6666004)(2616005)(426003)(336012)(83380400001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 23:48:49.2384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f406b4a7-764a-40c5-4fbf-08db36304db1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4152
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_FILL_THIS_FORM_SHORT
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 03:37:00PM -0800, Dave Hansen wrote:
> On 2/20/23 10:38, Michael Roth wrote:
> > +		/*
> > +		 * TODO: The RMP entry's hugepage bit is ignored for
> > +		 * shared/unassigned pages. Either handle looping through each
> > +		 * sub-page as part of snp_make_page_shared(), or remove the
> > +		 * level argument.
> > +		 */
> > +		if (op == SNP_PAGE_STATE_PRIVATE && order &&
> > +		    IS_ALIGNED(gfn, 1 << order) && (gfn + (1 << order)) <= end) {
> > +			level = order_to_level(order);
> > +			npages = 1 << order;
> > +		}
> 
> That's a wee bit obtuse.
> 
> First of all, I assume that the 'RFC' is because of these TODOs and they
> won't survive to the point when you ask for this to be merged.

Yes, will make sure to have all the TODOs in the tree addressed before
dropping the RFC tag.

> 
> BTW, what keeps the restrictedmem_get_page() offset and the gfn aligned?

I don't think anything enforces that currently, but there is a TODO in the
UPM v10 patchset to enforce that:

  https://github.com/AMDESE/linux/commit/5c86db7f98701f614c48946b733f2542c962f139#diff-e7514a224c92c2e47224f99919405a37ee7edc4612953135229cfb6e07a680d8R2131

So currently this patch relies on the following:

 - the fact that the memslot alignment/sizes for a standard x86 guest's
   associated memory regions are 2M-aligned, so when they are bound to a
   restrictedmem FD they are naturally packed in at restrictedmem offsets
   that are also 2M-aligned. But of course we can't assume userspace will
   live up to this assumption and need the above TODO in KVM to enforce
   this when registering new memslots.

 - that restrictedmem/shmem will ensure that THPs are only allocated for
   restrictedmem offsets that are 2M-aligned. I think this enforcement
   happens in shmem_alloc_hugefolio().

which both seem to hold in testing. But it's probably a good idea to add
an explicit check for this, at least until KVM implements something to
enforce this earlier in guest life-cycle.

> 
> Let's start with this:
> 
> > +static inline u8 order_to_level(int order)
> > +{
> > +	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> > +
> > +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> > +		return PG_LEVEL_1G;
> > +
> > +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> > +		return PG_LEVEL_2M;
> > +
> > +	return PG_LEVEL_4K;
> > +}
> 
> Right now, 'order' comes only from restrictedmem_get_page(), which I dug
> out of:
> 
> > https://github.com/mdroth/linux/commit/c6792672cd11737fd255dff10b2d5b6bccc626a8
> 
> That order is *only* filled in by THPs.  That makes the PG_LEVEL_1G
> stuff here kinda silly.  I guess it might be seen as thorough, but it's
> dead code.  I'd probably just make this work on order==9 || order==0 and
> warn on anything else.

Ok, makes sense.

> 
> I'd also highly recommend some comments about how racy this all is.  I
> guess it probably works, but it would be good to add some comments about
> page splits and collapsing.

Collapsing while in this code path should be ok since the 4K sub-pages will
just end up getting mapped as 4K in RMP table. KVM MMU will then map
them into nested page table as 4K as well and we'll get non-optimal
performance, but things should otherwise work.

Splitting is a similar story: if we map as 2M in RMP table, and then
afterward the page gets split, then KVM MMU during fault time would map
the pages in the NPT as 4K, and when the guest attempts to access
private pages of this sort they'll generate a nested page fault with
PFERR_GUEST_RMP_BIT and PFERR_GUEST_SIZEM_BIT set, and the code in
handle_rmp_page_fault() will issue a PSMASH instruction to split the
2M RMP entry into 512 4K RMP entries.

Will add some comments around this.

> 
> It's also not obvious why this only cares about private pages.

Mainly because the shared memory that actually get mapped into the guest
is always shared in the RMP table. It is normal VMA memory that is not
allocated by UPM/restrictedmem. We will never attempt to make them
private, so there is never a need to bother with switching them back to
shared.

So we only need to handle RMP updates for the UPM/restrictedmem PFNs.
Obviously for shared->private conversion before mapping it into the
guest, but also for private->shared conversion since we will still
get RMP check failures if we try to leave the PFNs as private in the
RMP table and map the above-mentioned VMA memory into the guest
instead.

Will add some more comments around this.

> 
> Anyway, this is the exact kind of thing where I really like a
> well-commented helper:
> 
> bool can_install_large_rmp_entry(gfn, order)
> {
> 	// small pages, blah blah
> 	if (!order)
> 		return false;
> 
> 	// The region being updated must be aligned
> 	if (!IS_ALIGNED(gfn, 1 << order))
> 		return false;
> 	// ... and fit
> 	if (gfn + (1 << order)) > end)
> 		return false;
> 
> 	return true;	
> }
> 
> Which gets used like this:
> 
> 	if (op == SNP_PAGE_STATE_PRIVATE &&
> 	    can_install_large_rmp_entry(gfn, order)) {
> 		level = ...
> 	}

Makes sense, will implement something along these lines.

Thanks!

-Mike

