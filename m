Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB7570CF89
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbjEWAkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbjEWAKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:10:53 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3379B1FE2;
        Mon, 22 May 2023 16:58:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRlLCAtVU5gXVGgNCrAAwn5hY4/wi4sEb29t0tpL/DP0ziCQGVql9PRbq86HENmIuE44me/Qu+zE0rj36YeT3X3o4p9YwvT5iuDp8VGLnNGin0Faj6NsP2SmCDwLeb+8jrpNeF/+a1+XiGFEd+65Crey5UJBWW1ZS7GQX9emCY1ZDiQRzYJuHWhGMu0qLuOqH5dYVG9/9anGxg1AGkFOojpmUUIdWymSY8ksc7z/MLJhsz+4cqVrLyV1c0Etty/POdHTtjsWxKWq9mCDKRHRVKrK2FzUHMb5BlNjY3aIcjOXueoYFDH5q3XZYD8vxA8ttmZXGgNgN9UEJZO6ckdbLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEkNr6AJaFwgL/jaMc+MNaYqZQ0e3Z3gtv4fA3zmPqk=;
 b=dyp4V60fK8PZpvvqp3aDFmRnm/L9KysZArF6geT8HXvZKrh51M082i9TY9ypWiiclrpVZINclx4qXytIGLw9AmOZRwklLZVOpwBsUbexnJko7FBgVR+OwpsWLeJq/tM1j9ISh3s2tQNLNlWw/S6+g4f5Db065lnXJLisLUweZKQ21dbZ/nUL7rFZRzdlxkOnv3B+3pqT1cl9upDkq0696gr0zv5KdaezD/a8qhKcnxvOK5m9pIh+QSIMFV6YZlMB36CxPjQUGRUer0w2d2tpGZ7oP2XX+bxjKpIDJT39HPXAy5zCkWDRdn1m2tf7G3gIWcXBHnRyCkqEktbIfzOyJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEkNr6AJaFwgL/jaMc+MNaYqZQ0e3Z3gtv4fA3zmPqk=;
 b=Zh4fcYZHp5XpVXcSRIrhxHUIeYLif8rldBn7g5hdp82gwt8uWsK2283lJf8WXKWe7XjGxFt85HTL8IAhblOaJ2wa8mmZenf8LcDeQv37z93aZ+U+5C0K2NuWeD9FCj2SetswkNlpYN1p2knZEq6/6v15IYbdCdnFbwA58yDREZ4=
Received: from BYAPR01CA0024.prod.exchangelabs.com (2603:10b6:a02:80::37) by
 BL3PR12MB6524.namprd12.prod.outlook.com (2603:10b6:208:38c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Mon, 22 May 2023 23:58:56 +0000
Received: from DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a02:80:cafe::8d) by BYAPR01CA0024.outlook.office365.com
 (2603:10b6:a02:80::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Mon, 22 May 2023 23:58:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT074.mail.protection.outlook.com (10.13.173.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.29 via Frontend Transport; Mon, 22 May 2023 23:58:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 22 May
 2023 18:58:55 -0500
Date:   Mon, 22 May 2023 18:58:38 -0500
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
Message-ID: <20230522235838.ov3722lcusotzlvo@amd.com>
References: <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com>
 <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com>
 <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com>
 <20230512002124.3sap3kzxpegwj3n2@amd.com>
 <ZF5+5g5hI7xyyIAS@google.com>
 <20230522135036.wnvsmryhkvstwvw2@amd.com>
 <ZGuh1J6AOw5v2R1W@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGuh1J6AOw5v2R1W@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT074:EE_|BL3PR12MB6524:EE_
X-MS-Office365-Filtering-Correlation-Id: e634784c-1884-43c9-a1cd-08db5b2080da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Rh99mTMmhnIXw8qCl8Drff8gezCnx/6qMoZp+MtD+TAAA/u90FWsLqqLhhybmx3JNp0345XVpjpWcevAxBoBFOomucB2xnBu8hd6uAezjTISLA9hJzuP7fhXnGK61tiyJEEEMYZ6+YqmbJ0/BLPNtXeicex01zWHOWaGHyW2othcCEePQ7nureBgNqqhCM/xU6lseTIOij5Ugv1RDb+bP0ERmonVDvS8D3wcPG3pQn9Rx81Z9hcPrh6RLRGlR8LeqCcjqQAAGMZyOJf8MAk9jHXzvVaNB5WeSknJ5BT/U5KlfN0Q6cD8ioKhnWvZnL58wBuJIVBX7l9yCbXgDYElJBTdedR6w3ca7wk/LLST+o/C/6SjNikAcf7LR/fqQpRAQQjvjwYajx9uUhOpj9E4RAhtAc5u083+8JdJEdOZTLtX0BfwDC+tqO6PxSbpIQNEHencQOAoCcnwxJrmbZeah2XnOZkua2nMdiNCTE+aRu4agjX9mZWqjno5+bkKbOqBaGa8TKvvhYY7C6DCGxyeZgxbUkOg+o0M+RSXfxFaRAi3+erjqgvyQgcZGnl4xij8wdiTqNukLgQoI+TmjpowZgw91p1NUAMahrsfFtIiqKHYN/nqvoQf3roqlAym1GDHQVl+KxTuaQBC8RLzVU7haXf61Kael5RCXKSrHf8o6eLOGMs952fdodj46OxDYPaJY5GnR2xc2nuDK7mDrIFH2lHLBZFHEfnJW/pUtu2Jap/xCEdadnSCojOZ4PUy8W1YVAD5TF6+xC7z8TO5b6lnQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(81166007)(356005)(8676002)(8936002)(7416002)(5660300002)(82740400003)(40460700003)(47076005)(16526019)(40480700001)(26005)(2906002)(1076003)(186003)(2616005)(36756003)(336012)(426003)(83380400001)(82310400005)(44832011)(36860700001)(86362001)(54906003)(316002)(6666004)(6916009)(4326008)(66899021)(478600001)(70206006)(70586007)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 23:58:56.1012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e634784c-1884-43c9-a1cd-08db5b2080da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6524
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 10:09:40AM -0700, Sean Christopherson wrote:
> On Mon, May 22, 2023, Michael Roth wrote:
> > On Fri, May 12, 2023 at 11:01:10AM -0700, Sean Christopherson wrote:
> > > On Thu, May 11, 2023, Michael Roth wrote:
> > I put together a tree with some fixups that are needed for against the
> > kvm_gmem_solo base tree, and a set of hooks to handle invalidations,
> > preparing the initial private state as suggested above, and a
> > platform-configurable mask that the x86 MMU code can use for determining
> > whether a fault is for private vs. shared pages.
> > 
> >   KVM: x86: Determine shared/private faults using a configurable mask
> >   ^ for TDX we could trivially add an inverted analogue of the mask/logic
> >   KVM: x86: Use full 64-bit error code for kvm_mmu_do_page_fault
> >   KVM: x86: Add platform hooks for private memory invalidations
> 
> Hrm, I'd prefer to avoid adding another hook for this case, arch code already has
> a "hook" in the form of kvm_unmap_gfn_range().  We'd probably just need a
> kvm_gfn_range.is_private flag to communicate to arch/vendor code that the memory
> being zapped is private.

kvm_unmap_gfn_range() does however get called with kvm->mmu_lock held so
it might be tricky to tie RMP updates into that path.

> 
> That'd leave a gap for the unbind() case because kvm_unmap_gfn_range() is invoked
> if and only if there's an overlapping memslot.  I'll chew on that a bit to see if
> there's a way to cleanly handle that case without another hook.  I think it's worth
> mapping out exactly what we want unbind() to look like anyways, e.g. right now the
> code subtly relies on private memslots being immutable.

I thought the direction you sort of driving at was to completely decouple
RMP updates for physical pages from the KVM MMU map/unmap paths since the
life-cycles of those backing pages and associated RMP state are somewhat
separate from the state of the GFNs and kvm->mem_attr_array. It seems to
make sense when dealing with things like this unbind() case.

There's also cases like userspaces that opt to not discard memory after
conversions because they highly favor performance over memory usage. In
those cases it would make sense to defer marking the pages as shared in
the RMP until the FALLOC_FL_PUNCH_HOLE, rather than triggering it via
KVM MMU invalidation path after a conversion.

> 
> >   KVM: x86: Add platform hook for initializing private memory
> 
> This should also be unnecessary.  The call to kvm_gmem_get_pfn() is from arch
> code, KVM just needs to ensure the RMP is converted before acquiring mmu_lock,
> e.g. KVM has all the necessary info in kvm_tdp_mmu_page_fault().

I think that approach would work fine. The way I was thinking of things
is that KVM MMU would necessarily call kvm_gmem_get_pfn() to grab the
page before mapping it into the guest, so moving it out into an explicit
call should work just as well. That would also drop the need for the
__kvm_gmem_get_pfn() stuff I needed to add for the initial case where we
need to access the PFN prior to making it private.

> 
> The only reason to add another arch hook would be if we wanted to converted the
> RMP when _allocating_, e.g. to preconvert in response to fallocate() instead of
> waiting until #NPF.  But I think I would rather add a generic ioctl() to allow
> userspace to effectively prefault guest memory, e.g. to setup the RMP before
> running a vCPU.  Such an ioctl() would potentially be useful in other scenarios,
> e.g. on the dest during live migration to reduce jitter.

Agreed, deferring the RMPUPDATE until it's actually needed would give us
more flexibility on optimizing for things like lazy-acceptance.

For less-common scenarios like preallocation it makes sense to make that
an opt-in sort of thing for userspace to configure explicitly.

> 
> >   *fixup (kvm_gmem_solo): KVM: Fix end range calculation for MMU invalidations
> 
> There was another bug in this path.  The math for handling a non-zero offsets into
> the file was wrong.  The code now looks like:
> 
> 	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
> 		struct kvm_gfn_range gfn_range = {
> 			.start = slot->base_gfn + start - slot->gmem.index,

Sorry if I'm missing something here, but isn't there a risk that:

  start - slot->gmem.index

would be less than zero? E.g. starting GFN was 0, but current slot is bound
at some non-zero offset in the same gmem instance. I guess the warning below
shouldn't caught that, but it seems like a real scenario.

Since 'index' corresponds to the gmem offset of the current slot, is there any
reason not to do something like this?:

  .start = slot->base_gfn + index - slot->gmem.index,

But then, if that's the case, wouldn't index == slot->gmem.index? Suggesting
we case just simplify to this?:

  .start = slot->base_gfn,

-Mike

> 			.end = slot->base_gfn + min(end - slot->gmem.index, slot->npages),
> 			.slot = slot,
> 			.pte = __pte(0),
> 			.may_block = true,
> 		};
> 
> 		if (WARN_ON_ONCE(start < slot->gmem.index ||
> 				 end > slot->gmem.index + slot->npages))
> 			continue;
> 
> 		kvm_mmu_invalidate_range_add(kvm, gfn_range.start, gfn_range.end);
> 
> 		flush |= kvm_unmap_gfn_range(kvm, &gfn_range);
> 	}
