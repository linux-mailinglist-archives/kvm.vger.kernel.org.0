Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1C7153DFF
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 06:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgBFFFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 00:05:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:37740 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgBFFFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 00:05:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 21:05:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; 
   d="scan'208";a="254987822"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 05 Feb 2020 21:05:19 -0800
Date:   Wed, 5 Feb 2020 21:05:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 01/19] KVM: x86: Allocate new rmap and large page
 tracking when moving memslot
Message-ID: <20200206050518.GA9401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-2-sean.j.christopherson@intel.com>
 <20200205214952.GD387680@xz-x1>
 <20200205235533.GA7631@linux.intel.com>
 <20200206020031.GJ387680@xz-x1>
 <20200206021714.GB7631@linux.intel.com>
 <20200206025858.GK387680@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206025858.GK387680@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 09:58:58PM -0500, Peter Xu wrote:
> On Wed, Feb 05, 2020 at 06:17:15PM -0800, Sean Christopherson wrote:
> > On Wed, Feb 05, 2020 at 09:00:31PM -0500, Peter Xu wrote:
> > > On Wed, Feb 05, 2020 at 03:55:33PM -0800, Sean Christopherson wrote:
> > > > On Wed, Feb 05, 2020 at 04:49:52PM -0500, Peter Xu wrote:
> > > > > Instead of calling kvm_arch_create_memslot() explicitly again here,
> > > > > can it be replaced by below?
> > > > > 
> > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > index 72b45f491692..85a7b02fd752 100644
> > > > > --- a/virt/kvm/kvm_main.c
> > > > > +++ b/virt/kvm/kvm_main.c
> > > > > @@ -1144,7 +1144,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > > > >                 new.dirty_bitmap = NULL;
> > > > >  
> > > > >         r = -ENOMEM;
> > > > > -       if (change == KVM_MR_CREATE) {
> > > > > +       if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
> > > > >                 new.userspace_addr = mem->userspace_addr;
> > > > >  
> > > > >                 if (kvm_arch_create_memslot(kvm, &new, npages))
> > > > 
> > > > No, because other architectures don't need to re-allocate new metadata on
> > > > MOVE and rely on __kvm_set_memory_region() to copy @arch from old to new,
> > > > e.g. see kvmppc_core_create_memslot_hv().
> > > 
> > > Yes it's only required in x86, but iiuc it also will still work for
> > > ppc?  Say, in that case ppc won't copy @arch from old to new, and
> > > kvmppc_core_free_memslot_hv() will free the old, however it should
> > > still work.
> > 
> > No, calling kvm_arch_create_memslot() for MOVE will result in PPC leaking
> > memory due to overwriting slot->arch.rmap with a new allocation.
> 
> Why?  For the MOVE case, kvm_arch_create_memslot() will create a new
> rmap for the "new" memslot.  If the whole procedure succeeded,
> kvm_free_memslot() will free the old rmap.  If it failed,
> kvm_free_memslot() will free the new rmap if !NULL.  Looks fine?

Oh, I see what you're suggesting.   Please god no.

This is a bug fix that needs to be backported to stable.  Arbitrarily
changing PPC behavior is a bad idea, especially since I don't know squat
about the PPC rmap behavior.

If it happens to fix a PPC rmap bug, then PPC should get an explicit fix.
If it's not a bug fix, then at best it is a minor performance hit due to an
extra allocation and the need to refill the rmap.  Worst case scenario it
breaks PPC.

And unless this were a temporary change, which would be silly, I would have
to carry forward the change into "KVM: PPC: Move memslot memory allocation
into prepare_memory_region()", and again, I don't know squat about PPC.

I also don't want to effectively introduce a misnamed function, even if
only temporarily, e.g. it's kvm_arch_create_memslot(), not
kvm_arch_create_or_move_memslot(), because the whole flow gets reworked a
few patches later.
