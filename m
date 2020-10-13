Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A81B28C8F1
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 09:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389868AbgJMHDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 03:03:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:17265 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389808AbgJMHDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 03:03:33 -0400
IronPort-SDR: ZsVtQJ5107ilPUaeUIJTXEIE3ckXWWdUYRIBjNbWdaHejpLGpKGQhshq2SfonCKvn5UP2s7R+I
 wu96hnUfX/fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165974980"
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="165974980"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 00:03:32 -0700
IronPort-SDR: yiC8yNDOFHFMq6VXclrifsMfmqj6MBvsTppvCcYTh5upRUuK1B85ppDfm3fitbb9opdaiA4hn1
 gvz6ZX3fKJjw==
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="330004494"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 00:03:32 -0700
Date:   Tue, 13 Oct 2020 00:03:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     harry harry <hiharryharryharry@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
Message-ID: <20201013070329.GC11344@linux.intel.com>
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com>
 <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
 <20201013045245.GA11344@linux.intel.com>
 <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 13, 2020 at 01:33:28AM -0400, harry harry wrote:
> > > Do you mean that GPAs are different from their corresponding HVAs when
> > > KVM does the walks (as you said above) in software?
> >
> > What do you mean by "different"?  GPAs and HVAs are two completely
> different
> > address spaces.
> 
> Let me give you one concrete example as follows to explain the meaning of
> ``different''.
> 
> Suppose a program is running in a single-vCPU VM. The program allocates and
> references one page (e.g., array[1024*4]). Assume that allocating and
> referencing the page in the guest OS triggers a page fault and host OS
> allocates a machine page to back it.
> 
> Assume that GVA of array[0] is 0x000000000021 and its corresponding GPA is
> 0x0000000000000081. I think array[0]'s corresponding HVA should also be
> 0x0000000000000081, which is the same as array[0]'s GPA. If array[0]'s HVA
> is not 0x0000000000000081, array[0]'s GPA is* different* from its
> corresponding HVA.
> 
> Now, let's assume array[0]'s GPA is different from its corresponding HVA. I
> think there might be one issue like this: I think MMU's hardware logic to
> translate ``GPA ->[extended/nested page tables] -> HPA''[1] should be the
> same as ``VA-> [page tables] -> PA"[2]; if true, how does KVM find the
> correct HPA with the different HVA (e.g., array[0]'s HVA is not
> 0x0000000000000081) when there are EPT violations?

This is where memslots come in.  Think of memslots as a one-level page tablea
that translate GPAs to HVAs.  A memslot, set by userspace, tells KVM the
corresponding HVA for a given GPA.

Before the guest is running (assuming host userspace isn't broken), the
userspace VMM will first allocate virtual memory (HVA) for all physical
memory it wants to map into the guest (GPA).  It then tells KVM how to
translate a given GPA to its HVA by creating a memslot.

To avoid getting lost in a tangent about page offsets, let's assume array[0]'s
GPA = 0xa000.  For KVM to create a GPA->HPA mapping for the guest, there _must_
be a memslot that translates GPA 0xa000 to an HVA[*].  Let's say HVA = 0xb000.

On an EPT violation, KVM does a memslot lookup to translate the GPA (0xa000) to
its HVA (0xb000), and then walks the host page tables to translate the HVA into
a HPA (let's say that ends up being 0xc000).  KVM then stuffs 0xc000 into the
EPT tables, which yields:

  GPA    -> HVA    (KVM memslots)
  0xa000    0xb000

  HVA    -> HPA    (host page tables)
  0xb000    0xc000

  GPA    -> HPA    (extended page tables)
  0xa000    0xc000

To keep the EPT tables synchronized with the host page tables, if HVA->HPA
changes, e.g. HVA 0xb000 is remapped to HPA 0xd000, then KVM will get notified
by the host kernel that the HVA has been unmapped and will find and unmap
the corresponding GPA (again via memslots) to HPA translations.

Ditto for the case where userspace moves a memslot, e.g. if HVA is changed
to 0xe000, KVM will first unmap all old GPA->HPA translations so that accesses
to GPA 0xa000 from the guest will take an EPT violation and see the new HVA
(and presumably a new HPA).

[*] If there is no memslot, KVM will exit to userspace on the EPT violation,
    with some information about what GPA the guest was accessing.  This is how
    emulated MMIO is implemented, e.g. userspace intentionally doesn't back a
    GPA with a memslot so that it can trap guest accesses to said GPA for the
    purpose of emulating a device.

> [1] Please note that this hardware walk is the last step, which only
> translates the guest physical address to the host physical address through
> the four-level nested page table.
> [2] Please note that this hardware walk assumes translating the VA to the
> PA without virtualization involvement.
> 
> Please note that the above addresses are not real and just use for
> explanations.
> 
> Thanks,
> Harry
