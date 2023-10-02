Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DEA7B577E
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 18:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbjJBPx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 11:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237798AbjJBPxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 11:53:54 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2067.outbound.protection.outlook.com [40.107.101.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515EF93;
        Mon,  2 Oct 2023 08:53:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEns1QkFzKtXApRmiAG2Gkj4nKCQTLfnCyQLoQs3lfC0xNJJqBcsnh8B9txjX4caInnXbQC7ihNstMwyd36DnSDmodJM1A4nHCVztTbm6w3f20KoSx6ls2lHrHYpwVLBEWngy/qov3MbL8BnvRQigq2SomF8pgwINvm+LeAHXg23EKY7ee4O0X6TF5QluAfPvalMdaB8Wl3OW99sJZpPlpGIaRZwL+1dKyr6e/SQjHPmDepK6+wnJPgFdX8GpJ9Y02gHWDCBZmw4bueUP+SFor4oQVlFN1Ikr66BCLoJjx2TUlTjn6UFsnAlN7ColAg/hEwIgEj08THK7Oqvc/2L1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNnmgDc8c3pehj6mUput3+lQtGE340T2lQ2UflUBSAc=;
 b=fm9YLIBKE0UG/dCUhnz6rU50dUit6c5e5lSbFDQDYBHzu3k8+7WAnBseqsmpRvT0/bPhD2lRfN5rukgujpiSYesW3JjJxB7K9SO9pkHhUu1EfUXjIVY1X4e9SQcxviVoQotc0ENU+bUao/vMmscI8pzvXKcQrQIH/WIo2PYG4e6aCCrTcZCD7EXBp9CtjBMckmOc6/Pohie6lCDgIgqGKRLHZgWZX7AjpIHVIWQWUCoke/8rEhY9dhW2LwMBqZ4N4DaaI3bi1AiSk1oyOUU+vkImq+sbNp/Z954iVdQOC3PwIWNx44ULZpJFI455NSlFFc/0Ri9yHfUiekct8KNPeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNnmgDc8c3pehj6mUput3+lQtGE340T2lQ2UflUBSAc=;
 b=KUCO643+3ZzieUPLgF7+IvBZdMPbQla1sqUkvuxIQVpN+ozxmV44tr5C4UPXl8uhDLzTZwPdOM5vQHnmFFYQo4F17BffQd21ioLv+sg5Ap7APEPzvNRWST154bPZ7ntLYSfNQb8VOMup8be+pijBcYM70vETzXzYfiELwB/6i1A=
Received: from PH7PR13CA0001.namprd13.prod.outlook.com (2603:10b6:510:174::7)
 by BN9PR12MB5193.namprd12.prod.outlook.com (2603:10b6:408:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25; Mon, 2 Oct
 2023 15:53:48 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:510:174:cafe::6f) by PH7PR13CA0001.outlook.office365.com
 (2603:10b6:510:174::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.23 via Frontend
 Transport; Mon, 2 Oct 2023 15:53:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.21 via Frontend Transport; Mon, 2 Oct 2023 15:53:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 2 Oct
 2023 10:53:47 -0500
Date:   Mon, 2 Oct 2023 10:53:30 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 06/13] KVM: Disallow hugepages for incompatible gmem
 bindings, but let 'em succeed
Message-ID: <20231002155330.lguyhqgy64rhko4p@amd.com>
References: <20230921203331.3746712-1-seanjc@google.com>
 <20230921203331.3746712-7-seanjc@google.com>
 <20230922224210.6klwbphnsk5j2wft@amd.com>
 <ZRXGl44g8oD-FtNy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZRXGl44g8oD-FtNy@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|BN9PR12MB5193:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b5e37a-de24-4b91-99b7-08dbc35fc403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ePe2vVegm3ALouVmXbC0OuP2kQ3DtC5v+XTsTJpf29E6Jbh5p/U4vvdA6hThHdk1I6k1jvTyKjldCct35a1rNWqZHMeI3KUhmCsDIvp3KizgafP1fLUlul1uB4/gfS8/3+My3IMlfvKy1H+731NCW7F2C574SCAbqFjfwMI9N8oHk1gE/JlHMF/OVk+9mJczjuUT/P/+eeYRgN11nL8IxEhz0ZSt+etjoR35U7GJN6FDkAHslOIrarzD1abEAo3xE5a9Oysh9aPbq6PkU/JLjgyQZgSa55DxrXr8r0nNQcK64N5soD5EvJ3Ud6BoNyrRBjkqZbM1w1zUItjCDq18KckCd+pa50mrRkbn9f+p2q3vo/kRBRxxCayc2MQNHVbGkvvFgK+Hn8y7+KZPqN8q/exN6bYhUaiVuHWtl/8HuwvvpGHR6yGvNV7fg8tTAsMVrsD/tXjNYclYDjYm4EWVjzQw3loHCpTEvYyYwfmd28aOXQcJPkf8Bk9oJk5NzwfK8TNZ0XAgIHCY0uS0eXsP/ziyNYpGVSF4u8PHo107/tLJ6crV/Fn7GiW1bikvmKYbbGlt1vYvn2WFvcdR3QPvOBWTM9VGMWFRr7b3xjLTWuXqYuGdwVe5L+skpbmVmip3+KQqVXLY90ovnYK84dH7hpdD0xZMjKxYgLDeKR7MthIw8vnCVk0wf3JcbkDD53mRmyR3W6o2e9MbuSJQgmxFpJbfwkOTjNkRHUjt3seiXLgvRdf1OWfkLdu+/2wizR9/IQdA4WdtnxvkowHYThew4aUoof/4d7hwe0ghQQbilXs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(396003)(39860400002)(230922051799003)(186009)(1800799009)(82310400011)(64100799003)(451199024)(36840700001)(46966006)(40470700004)(40460700003)(2906002)(426003)(1076003)(2616005)(6666004)(356005)(6916009)(41300700001)(86362001)(54906003)(82740400003)(36860700001)(16526019)(478600001)(81166007)(83380400001)(966005)(26005)(47076005)(336012)(40480700001)(70586007)(316002)(44832011)(4326008)(8676002)(70206006)(5660300002)(36756003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 15:53:48.0311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b5e37a-de24-4b91-99b7-08dbc35fc403
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5193
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023 at 11:31:51AM -0700, Sean Christopherson wrote:
> On Fri, Sep 22, 2023, Michael Roth wrote:
> > On Thu, Sep 21, 2023 at 01:33:23PM -0700, Sean Christopherson wrote:
> > > +	/*
> > > +	 * For simplicity, allow mapping a hugepage if and only if the entire
> > > +	 * binding is compatible, i.e. don't bother supporting mapping interior
> > > +	 * sub-ranges with hugepages (unless userspace comes up with a *really*
> > > +	 * strong use case for needing hugepages within unaligned bindings).
> > > +	 */
> > > +	if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
> > > +	    !IS_ALIGNED(slot->npages, 1ull << *max_order))
> > > +		*max_order = 0;
> > 
> > Thanks for working this in. Unfortunately on x86 the bulk of guest memory
> > ends up getting slotted directly above legacy regions at GFN 0x100, 
> 
> Can you provide an example?  I'm struggling to understand what the layout actually
> is.  I don't think it changes the story for the kernel, but it sounds like there
> might be room for optimization in QEMU?  Or more likely, I just don't understand
> what you're saying :-)

Here's one example, which seems to be fairly normal for an x86 boot:

  kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000 ua=0x7f24afc00000 ret=0 restricted_fd=19 restricted_offset=0x0
  ^ QEMU creates Slot 0 for all of main guest RAM
  kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x0 gpa=0x0 size=0x0 ua=0x7f24afc00000 ret=0 restricted_fd=19 restricted_offset=0x0
  kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0xc0000 ua=0x7f24afc00000 ret=0 restricted_fd=19 restricted_offset=0x0
  kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x6 gpa=0xc0000 size=0x20000 ua=0x7f2575000000 ret=0 restricted_fd=33 restricted_offset=0x0
  kvm_set_user_memory AddrSpace#0 Slot#4 flags=0x6 gpa=0xe0000 size=0x20000 ua=0x7f2575400000 ret=0 restricted_fd=31 restricted_offset=0x0
  ^ legacy regions are created and mapped on top of GPA ranges [0xc0000:0xe0000) and [0xe0000:0x100000)
  kvm_set_user_memory AddrSpace#0 Slot#5 flags=0x4 gpa=0x100000 size=0x7ff00000 ua=0x7f24afd00000 ret=0 restricted_fd=19 restricted_offset=0x100000
  ^ QEMU divides Slot 0 into Slot 0 at [0x0:0xc0000) and Slot 5 at [0x100000:0x80000000)
    Both Slots still share the same backing memory allocation, so same gmem
    fd 19 is used,but Slot 5 is assigned to offset 0x100000, whih is not
    2M-aligned

I tried messing with QEMU handling to pad out guest_memfd offsets to 2MB
boundaries but then the inode size needs to be enlarged to account for it
and things get a bit messy. Not sure if there are alternative approaches
that can be taken from userspace, but with normal malloc()'d or mmap()'d
backing memory the kernel can still allocate a 2MB backing page for the
[0x0:0x200000) range and I think KVM still handles that when setting up
NPT of sub-ranges so there might not be much room for further optimization
there.

> 
> > so the associated slot still ends failing these alignment checks if it tries
> > to match the gmemfd offsets up with the shared RAM/memfd offsets.
> > 
> > I tried to work around it in userspace by padding the gmemfd offset of
> > each slot to the next 2M boundary, but that also requires dynamically
> > growing the gmemfd inode to account for the padding of each new slot and
> > it gets ugly enough that I'm not sure it's any better than your
> > suggested alternative of using a unique gmemfd for each slot.
> > 
> > But what if we relax the check to simply make sure that any large folio
> > must is fully-contained by the range of the slot is bound to? It *seems*
> > like that would still avoid stuff like mapping 2M pages in the NPT (or
> > setting up 2M RMP table entries) that aren't fully contained by a slot
> > while still allowing the bulk of guest memory to get mapped as 2M. Are
> > there other edge cases to consider?
> > 
> > The following seems to work for a basic 16GB SNP guest at least:
> > 
> > diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> > index 9109bf5751ee..e73128d4ebc2 100644
> > --- a/virt/kvm/guest_mem.c
> > +++ b/virt/kvm/guest_mem.c
> > @@ -618,6 +618,7 @@ int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >                        gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prep)
> >  {
> >         pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
> > +       pgoff_t huge_index;
> >         struct kvm_gmem *gmem;
> >         struct folio *folio;
> >         struct page *page;
> > @@ -662,9 +663,12 @@ int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >          * sub-ranges with hugepages (unless userspace comes up with a *really*
> >          * strong use case for needing hugepages within unaligned bindings).
> >          */
> > -       if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
> > -           !IS_ALIGNED(slot->npages, 1ull << *max_order))
> > +       huge_index = round_down(index, 1ull << *max_order);
> 
> Why not use ALIGN() here?  The size is obviously a power-of-2.  Or is my math
> even worse than I thought?

I actually only originally used round_down() because kvm_gmem_get_huge_folio()
was taking that approach, but I still ended up using ALIGN() below so sorry
if the inconsistency caused any confusion. I switched to using ALIGN() above
and it works fine.

> 
> > +       if (huge_index < ALIGN(slot->gmem.pgoff, 1ull << *max_order) ||
> > +           huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages) {
> 
> Argh, I keep forgetting that the MMU is responsible for handling misaligned gfns.
> Yeah, this looks right.
> 
> Can you post this as a proper patch, on top of my fixes?  And without the pr_debug().
> That'll be the easiest for me to apply+squash when the time comes.

Sure, I submitted a revised patch on top of kvm-x86:

  https://lore.kernel.org/lkml/20231002133342.195882-1-michael.roth@amd.com/T/#u

I ran into a separate issue trying to test it and submitted a patch for that
here:

  https://lore.kernel.org/lkml/20231002133230.195738-1-michael.roth@amd.com/T/#u

-Mike

> 
> Thanks much!
