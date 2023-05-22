Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBA470C026
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 15:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbjEVNwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 09:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbjEVNwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 09:52:04 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9FB1B0;
        Mon, 22 May 2023 06:51:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAfDda/9fSZJvo+9gctfLMdyIqYuhMzp6CUTYNAbQX6f6mGp8mNmU3xrDvIIjcjfyKuxmnG9o67HS/xXla7DQm59RjtzdQXiPlC9xmcr5QZMFDDv6dYdjaPxOPthqzRWgUTO8/in8Oe564JPvFo4oPl+Ds+GF/kJMOFfmnJrR8qtTo/QIg/BKT/ax9GPFt8zCeQbqIObzIBtzaE+nPbTm+lu/+ukcA5VXBplIjHJB0BjoOX6g7EhO7ps1QUl0fqYnh7r5Tw8r3f9KDvxqGGil3a93MJ7qiXCUqMSW4kowpYA86N7DgyITW8mcbODix/lhSyS+ifH/6wyQbtOrK1vqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76cSel3QToqev4Pc0eePM1AhngzwT3EPPY5BzurTtrk=;
 b=FESSN+8lSDg7rjviH4JiKqaxi4KdDoiBdhmvbChqgoeyXoKLtQDYUaSGBswsKyH5c07L4wDcD52Xz72KE7PHidBF5/7yWIxJdHTXGuTTvreV3d6Y4lb7N/aqF0IfPPfovipu9ZPyeuc4BdCwh9Dt7XsS81VnBu4FLluYJGQtXEUGOxj80V1ULrRyLTv0V6qkf3ODUpNc/vtlK4ZOUwbxZb4Xjbvo4ZUygSRBFmRhEBqMXkXO7i9P1Mmg4LQHAJgu9e6yM84J3wc+7H7rsWENhaiEgadsTRl5Tdk6MO4o49mPMYJsvJRKXvuvum/s3+RedfOrNauWBb2brWj7XV5sUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76cSel3QToqev4Pc0eePM1AhngzwT3EPPY5BzurTtrk=;
 b=4DvdRtwiJKn/V8PIZv92j3zn9NFOaoWIMXFOYRevYH3g2oYLALkhx+9d6gSdDJ5QeLHqfkNKdrgqC/z1cbBRDE+XfnV3Y9sP3QeSFduriiNfxU5tDWQCPpJqx52Xx5xplIw3nFM7xJGxEPiGNYwNDscbqD+5vsRfwHpA8it2WDQ=
Received: from DM6PR13CA0042.namprd13.prod.outlook.com (2603:10b6:5:134::19)
 by DS0PR12MB8245.namprd12.prod.outlook.com (2603:10b6:8:f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 13:51:35 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::82) by DM6PR13CA0042.outlook.office365.com
 (2603:10b6:5:134::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.13 via Frontend
 Transport; Mon, 22 May 2023 13:51:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.29 via Frontend Transport; Mon, 22 May 2023 13:51:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 22 May
 2023 08:51:34 -0500
Date:   Mon, 22 May 2023 08:50:36 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        <dhildenb@redhat.com>, Quentin Perret <qperret@google.com>,
        <tabba@google.com>, <wei.w.wang@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
Message-ID: <20230522135036.wnvsmryhkvstwvw2@amd.com>
References: <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com>
 <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com>
 <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com>
 <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com>
 <20230512002124.3sap3kzxpegwj3n2@amd.com>
 <ZF5+5g5hI7xyyIAS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZF5+5g5hI7xyyIAS@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT068:EE_|DS0PR12MB8245:EE_
X-MS-Office365-Filtering-Correlation-Id: 489b8569-1a8f-4152-f440-08db5acba835
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 669yamDJV32O+WolAsJL1aRFZnMcBQHJH1SteQdsOkYbNJDXEiL0myMzNWLxhYf+tvUEWYjMzdOqRkuzopy5KPthYjddQLBG8N83vtmNf78wb0V1X/6Z7IaJgWlCywenrOQTSsrM0iqAIUyNvyze3hQs+TxBG2rBqdmsACnapOBxNWzDun28JrLP4JCyMYs8clsgCsRPe/lSzf5Qxot+gNgilekxp6JmqD0jVxucUK8gkPlF7hGtLjucoKLY3lI0mboooYoft+2fSzvSXWOLKLJRPWM95wWdresWt5mh6VurzmTNyYKrj0HaU31DuOI0Xjk0r7gFEOEnEQXgIurxPpJeG66ruYzOvpHfq/OXkvybXKgVZIkMQ6w9H/0j6cKkSP7FV/Q7p2iuiv81YQ8c6Yr2V5HJOYC1WFQbpOCFO9RV4WQ7x2MgbC7+k95eWlmd1TTsC/YoPyDgdyguGv/8C5LeEEyWeRTdqt+28NkIewHH4mguc8eotExJgCSUJccBGCJyJS83EsMPnjqBOMN60BpfzjLtcPmowrRaL83HMnUgXIfkR+IO0ZBqc12OgjK/xE1bdpxDMfuYnWoOOeY2Pycob2Z4X11/PzbcXVZZNjOGR9ZPpnseOnufgYGvpgo1uvRK+caNNi7byxF7khk19dtgKAVibY6ZBUHLCxhxzDiNvsVSV0awzTeTcf5kb+vM1JXpIm9G91hy8lLAtRduPiDbZKHzFZY0CwI0zgx86JofzjjTYX06Ti5xhcfdbk+oFlbwRWBRe3PcyUUrDGnr0eKI3tPBRuceMSaMe7hH5Ko=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(36840700001)(46966006)(40470700004)(478600001)(54906003)(5660300002)(26005)(41300700001)(966005)(186003)(316002)(4326008)(6916009)(44832011)(1076003)(7416002)(336012)(8936002)(8676002)(426003)(16526019)(2906002)(47076005)(2616005)(36860700001)(83380400001)(70206006)(70586007)(82740400003)(356005)(81166007)(36756003)(82310400005)(40460700003)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 13:51:34.9401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 489b8569-1a8f-4152-f440-08db5acba835
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8245
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 11:01:10AM -0700, Sean Christopherson wrote:
> On Thu, May 11, 2023, Michael Roth wrote:
> > On Fri, Apr 21, 2023 at 06:33:26PM -0700, Sean Christopherson wrote:
> > > 
> > > Code is available here if folks want to take a look before any kind of formal
> > > posting:
> > > 
> > > 	https://github.com/sean-jc/linux.git x86/kvm_gmem_solo
> > 
> > Hi Sean,
> > 
> > I've been working on getting the SNP patches ported to this but I'm having
> > some trouble working out a reasonable scheme for how to work the
> > RMPUPDATE hooks into the proposed design.
> > 
> > One of the main things is kvm_gmem_punch_hole(): this is can free pages
> > back to the host whenever userspace feels like it. Pages that are still
> > marked private in the RMP table will blow up the host if they aren't returned
> > to the normal state before handing them back to the kernel. So I'm trying to
> > add a hook, orchestrated by kvm_arch_gmem_invalidate(), to handle that,
> > e.g.:
> > 
> >   static long kvm_gmem_punch_hole(struct file *file, int mode, loff_t offset,
> >                                   loff_t len)
> >   {
> >           struct kvm_gmem *gmem = file->private_data;
> >           pgoff_t start = offset >> PAGE_SHIFT;
> >           pgoff_t end = (offset + len) >> PAGE_SHIFT;
> >           struct kvm *kvm = gmem->kvm;
> >   
> >           /*
> >            * Bindings must stable across invalidation to ensure the start+end
> >            * are balanced.
> >            */
> >           filemap_invalidate_lock(file->f_mapping);
> >           kvm_gmem_invalidate_begin(kvm, gmem, start, end);
> >   
> >           /* Handle arch-specific cleanups before releasing pages */
> >           kvm_arch_gmem_invalidate(kvm, gmem, start, end);
> >           truncate_inode_pages_range(file->f_mapping, offset, offset + len);
> >   
> >           kvm_gmem_invalidate_end(kvm, gmem, start, end);
> >           filemap_invalidate_unlock(file->f_mapping);
> >   
> >           return 0;
> >   }
> > 
> > But there's another hook, kvm_arch_gmem_set_mem_attributes(), needed to put
> > the page in its intended state in the RMP table prior to mapping it into the
> > guest's NPT.
> 
> IMO, this approach is wrong.  kvm->mem_attr_array is the source of truth for whether
> userspace wants _guest_ physical pages mapped private vs. shared, but the attributes
> array has zero insight into the _host_ physical pages.  I.e. SNP shouldn't hook
> kvm_mem_attrs_changed(), because operating on the RMP from that code is fundamentally
> wrong.
> 
> A good analogy is moving a memslot (ignoring that AFAIK no VMM actually moves
> memslots, but it's a good analogy for KVM internals).  KVM needs to zap all mappings
> for the old memslot gfn, but KVM does not create mappings for the new memslot gfn.
> Same for changing attributes; unmap, but never map.
> 
> As for the unmapping side of things, kvm_unmap_gfn_range() will unmap all relevant
> NPT entries, and the elevated mmu_invalidate_in_progress will prevent KVM from
> establishing a new NPT mapping.  And mmu_invalidate_in_progress will reach '0' only
> after both truncation _and_ kvm_vm_ioctl_set_mem_attributes() complete, i.e. KVM
> can create new mappings only when both kvm->mem_attr_array and any relevant
> guest_mem bindings have reached steady state.
> 
> That leaves the question of when/where to do RMP updates.  Off the cuff, I think
> RMP updates (and I _think_ also TDX page conversions) should _always_ be done in
> the context of either (a) file truncation (make host owned due, a.k.a. TDX reclaim)
> or (b) allocating a new page/folio in guest_mem, a.k.a. kvm_gmem_get_folio().
> Under the hood, even though the gfn is the same, the backing pfn is different, i.e.
> installing a shared mapping should _never_ need to touch the RMP because pages
> common from the normal (non-guest_mem) pool must already be host owned.

Hi Sean, thanks for the suggestions.

I reworked things based on this approach and things seems to work out
pretty nicely for SNP.

I needed to add the hook to kvm_gmem_get_pfn() instead of
kvm_gmem_get_folio() because SNP needs to know the GFN in order to mark
the page as private in the RMP table, but otherwise I think things are
the same as what you had in mind. One downside to this approach is since
the hook always gets called during kvm_gmem_get_pfn(), we need to do an
extra RMP lookup to determine whether or not that page has already been
set to private state, vs. being able to assume it's already been put in
the expected state, but it's only a memory access so not a huge
overhead. Not sure if that would be a concern of not on the TDX side
though.

I put together a tree with some fixups that are needed for against the
kvm_gmem_solo base tree, and a set of hooks to handle invalidations,
preparing the initial private state as suggested above, and a
platform-configurable mask that the x86 MMU code can use for determining
whether a fault is for private vs. shared pages.

  KVM: x86: Determine shared/private faults using a configurable mask
  ^ for TDX we could trivially add an inverted analogue of the mask/logic
  KVM: x86: Use full 64-bit error code for kvm_mmu_do_page_fault
  KVM: x86: Add platform hooks for private memory invalidations
  KVM: x86: Add platform hook for initializing private memory
  *fixup (kvm_gmem_solo): KVM: Fix end range calculation for MMU invalidations
  *fixup (kvm_gmem_solo): KVM: selftests: update kvm_create_guest_memfd struct usage

  https://github.com/mdroth/linux/commits/kvm_gmem_solo_x86

I'm hoping these are similarly usable for TDX, but could use some input
from TDX folks on that aspect.

> > 
> > Keep in mind that RMP updates can't be done while holding KVM->mmu_lock
> > spinlock, because we also need to unmap pages from the directmap, which can
> > lead to scheduling-while-atomic BUG()s[1], so that's another constraint we
> > need to work around.

This concern also ends up going away since GFP_RECLAIM also has similar
issues when called under kvm->mmu_lock, so having the hook in
kvm_gmem_get_pfn() sort of guarantees we wouldn't hit issues with this.

-Mike

> > 
> > Thanks!
> > 
> > -Mike
> > 
> > [1] https://lore.kernel.org/linux-coco/20221214194056.161492-7-michael.roth@amd.com/T/#m45a1af063aa5ac0b9314d6a7d46eecb1253bba7a
> > 
> > > 
> > > [1] https://lore.kernel.org/all/ff5c5b97-acdf-9745-ebe5-c6609dd6322e@google.com
> > > [2] https://lore.kernel.org/all/20230418-anfallen-irdisch-6993a61be10b@brauner
> > > [3] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shutemov@linux.intel.com
