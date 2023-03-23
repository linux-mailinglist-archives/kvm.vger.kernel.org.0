Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F016C7014
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 19:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjCWSRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 14:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCWSR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 14:17:27 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987B73C3E;
        Thu, 23 Mar 2023 11:17:23 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id f16so23456042ljq.10;
        Thu, 23 Mar 2023 11:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679595442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAtmVPFHgz3nMYeSIqmwSwgwx6kJUPMTlKkGGHyUsGc=;
        b=MHYXE2ArjLNsbTNMAiXx9ZRWMLqJt7+ERGTrteqmM1juhLKCHdRbtiaymGN/c6Y7Np
         dRMYKW5z/6ddIelgYDLmO4xJtF8BW8wPHNBg7I6sY3P8YDvzb7uJCC5B7e6rddbTR1T/
         jbXP6TKPVH16Qozx9AFH4nejf4QJQtqQNZHEvDK5fmF7Vr5Vf6nMZbZGGvU0b5p/lQoe
         arQE6lsc/qnQn3KxJ6pHbOPoj+LP0amnisWNMIZQS1fe+D8+sIVoW9Cdufvyx5T0z2GU
         wTdp+P0Umg0JkC4TUdmDF9KhL7UL6OFV2d4zKIXTu+2R6OKmtRvtBI3jQR78vzkUVpQq
         Fahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679595442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CAtmVPFHgz3nMYeSIqmwSwgwx6kJUPMTlKkGGHyUsGc=;
        b=4PoK5ejhqPDXZGTLSWwRYscyCu7VqjD8uUgaQ0PfNn9GxZDiDkptNmIykXmQgAgyDr
         U7iNDYVhggBmIMTHiYwhwULnHMjdPcRLwaKpWi/jGD/FtUFgq/WSXFP8YBS6BuNwj8wf
         mm2NOdw6gzccWZ+vYv6H5ie8MCkWQfR6nLyA6B5rBBTZW8Aojg7HaZFv/G31M4p4b/SR
         jfDD43NNmeWNh7f4wgPvRmCZvt37KvpJGpQe1r88a9lt1+uRgaxurK3DQGyb4LpxrT/i
         mK3pBOYH55ik2Fg0dkaVswi/pGCCNRk2MBUH+tz649QBk2NVL21GQwMVTfipiSTrwNtC
         qYnA==
X-Gm-Message-State: AAQBX9de7M0bQH92RlX5HCAMY6DKVpZWIo05TcyvMqRKN8i0MHmlEld7
        yKUqdnPA3ZPsFRxCJFmBR+E=
X-Google-Smtp-Source: AKy350ZUgRchHs4aGOfL1NfN6e6Vwwf4TMFDgAOdEJ4iPMTrwipF4WUDd4EWH389WZFRwVr6en0vqw==
X-Received: by 2002:a2e:a99a:0:b0:29b:d3a0:1038 with SMTP id x26-20020a2ea99a000000b0029bd3a01038mr60333ljq.4.1679595441549;
        Thu, 23 Mar 2023 11:17:21 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id q28-20020ac2529c000000b004eaf8613bc3sm641262lfm.284.2023.03.23.11.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 11:17:21 -0700 (PDT)
Date:   Thu, 23 Mar 2023 20:17:16 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 02/56] KVM: x86: Add 'update_mem_attr' x86 op
Message-ID: <20230323201716.00007662.zhi.wang.linux@gmail.com>
In-Reply-To: <20230322015838.z3bwcrvi4gqag3q6@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-3-michael.roth@amd.com>
        <20230318045611.GE408922@ls.amr.corp.intel.com>
        <20230320180543.ly4jgu54hyamy2gl@amd.com>
        <20230321132136.00005234@gmail.com>
        <20230322015838.z3bwcrvi4gqag3q6@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Mar 2023 20:58:38 -0500
Michael Roth <michael.roth@amd.com> wrote:

> On Tue, Mar 21, 2023 at 01:21:36PM +0200, Zhi Wang wrote:
> > On Mon, 20 Mar 2023 13:05:43 -0500
> > Michael Roth <michael.roth@amd.com> wrote:
> > 
> > > On Fri, Mar 17, 2023 at 09:56:11PM -0700, Isaku Yamahata wrote:
> > > > On Mon, Feb 20, 2023 at 12:37:53PM -0600,
> > > > Michael Roth <michael.roth@amd.com> wrote:
> > > >   
> > > > > This callback will do any platform-specific handling needed for
> > > > > converting pages between shared/private.
> > > > > 
> > > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > > ---
> > > > >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> > > > >  arch/x86/include/asm/kvm_host.h    |  2 ++
> > > > >  arch/x86/kvm/mmu/mmu.c             | 13 +++++++++++++
> > > > >  include/linux/kvm_host.h           |  4 ++++
> > > > >  virt/kvm/kvm_main.c                | 29 +++++++++++++++++++++++++++++
> > > > >  5 files changed, 49 insertions(+)
> > > > > 
> > > > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > > > index 72183da010b8..a8aaf532c2ab 100644
> > > > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > > > @@ -132,6 +132,7 @@ KVM_X86_OP(complete_emulated_msr)
> > > > >  KVM_X86_OP(vcpu_deliver_sipi_vector)
> > > > >  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> > > > >  KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
> > > > > +KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
> > > > >  
> > > > >  #undef KVM_X86_OP
> > > > >  #undef KVM_X86_OP_OPTIONAL
> > > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > > index f856d689dda0..2da3fb2d5d1b 100644
> > > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > > @@ -1644,6 +1644,8 @@ struct kvm_x86_ops {
> > > > >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > > > >  			     int root_level);
> > > > >  	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
> > > > > +	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int attr,
> > > > > +			       gfn_t start, gfn_t end);
> > > > >  
> > > > >  	bool (*has_wbinvd_exit)(void);
> > > > >  
> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > index fb3f34b7391c..053bd77bbf52 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > > @@ -7251,4 +7251,17 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > > > >  		linfo_update_mixed(gfn, slot, level, mixed);
> > > > >  	}
> > > > >  }
> > > > > +
> > > > > +void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> > > > > +					 struct kvm_memory_slot *slot,
> > > > > +					 unsigned long attrs,
> > > > > +					 gfn_t start, gfn_t end)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	ret = static_call(kvm_x86_update_mem_attr)(slot, attrs, start, end);
> > > > > +	if (ret)
> > > > > +		pr_warn_ratelimited("Failed to update GFN range 0x%llx-0x%llx with attributes 0x%lx. Ret: %d\n",
> > > > > +				    start, end, attrs, ret);
> > > > > +}
> > > > >  #endif
> > > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > > index fdc59479b3e2..d200b8f45583 100644
> > > > > --- a/include/linux/kvm_host.h
> > > > > +++ b/include/linux/kvm_host.h
> > > > > @@ -2330,6 +2330,10 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > > > >  				    struct kvm_memory_slot *slot,
> > > > >  				    unsigned long attrs,
> > > > >  				    gfn_t start, gfn_t end);
> > > > > +void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> > > > > +					 struct kvm_memory_slot *slot,
> > > > > +					 unsigned long attrs,
> > > > > +					 gfn_t start, gfn_t end);
> > > > >  
> > > > >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> > > > >  {
> > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > index b68574ff6c30..8ec985f1c57d 100644
> > > > > --- a/virt/kvm/kvm_main.c
> > > > > +++ b/virt/kvm/kvm_main.c
> > > > > @@ -2561,6 +2561,32 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
> > > > >  		kvm_flush_remote_tlbs(kvm);
> > > > >  }
> > > > >  
> > > > > +static void kvm_post_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
> > > > > +				       gfn_t start_orig, gfn_t end_orig)
> > > > > +{
> > > > > +	struct kvm_memory_slot *slot;
> > > > > +	struct kvm_memslots *slots;
> > > > > +	struct kvm_memslot_iter iter;
> > > > > +	int i;
> > > > > +
> > > > > +	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> > > > > +		slots = __kvm_memslots(kvm, i);
> > > > > +
> > > > > +		kvm_for_each_memslot_in_gfn_range(&iter, slots, start_orig, end_orig) {
> > > > > +			gfn_t start, end;
> > > > > +
> > > > > +			slot = iter.slot;
> > > > > +			start = max(start_orig, slot->base_gfn);
> > > > > +			end = min(end_orig, slot->base_gfn + slot->npages);
> > > > > +
> > > > > +			if (start >= end)
> > > > > +				continue;
> > > > > +
> > > > > +			kvm_arch_post_set_memory_attributes(kvm, slot, attrs, start, end);
> > > > > +		}
> > > > > +	}
> > > > > +}
> > > > > +
> > > > >  static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > > > >  					   struct kvm_memory_attributes *attrs)
> > > > >  {
> > > > > @@ -2602,6 +2628,9 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > > > >  	kvm_mmu_invalidate_end(kvm);
> > > > >  	KVM_MMU_UNLOCK(kvm);
> > > > >  
> > > > > +	if (i > start)
> > > > > +		kvm_post_mem_attrs_changed(kvm, attrs->attributes, start, i);
> > > > > +  
> > > > 
> > > > Doesn't kvm_arch_set_memory_attributes() work for you? i.e the following patch.
> > > > The error check and pr_warn_ratelimited() can be pushed down into the callback.  
> > > 
> > > This is originally how I had but when CONFIG_PREEMPT_COUNT is set this
> > > will generate warnings for this callback as well as the invalidation
> > > callback as reported in v7 here:
> > > 
> > >   https://lore.kernel.org/lkml/Y80vhKwQyw8hS%2F22@notebook/
> > > 
> > > The main issue is that kvm_mem_attrs_changed() is called while holding
> > > the KVM MMU lock, which disables preemption. But when updating
> > > attributes for SNP, we also need to remove private pages from kernel
> > > directmap, which involves acquiring a mutex which results in
> > > "BUG: scheduling while atomic" warnings.
> > > 
> > > So that's why we ended up somewhat duplicating some of the logic and
> > > using a separate callback chain that happens out of KVM MMU lock.
> > 
> > Let's split the things of changing memory attributes:
> > 
> > 1) Update the memory attributes in the xa array (Both TDX and SNP)
> > 2) Zapping the EPT/NPT mappings (Required by TDX)
> > 3) Update RMP table (Required by SNP)
> > 4) Update the directmap of kernel (SNP, but I guess TDX needs it as well)
> 

Thanks for the effort of detailed reply. It is very informative.

> I'm not so sure TDX requires this. I was under that impression, but
> Kirill raised some doubts about this and I'm not sure it's been
> confirmed. If it's purely an SNP thing then there may not be much value
> in creating a separate callback for it:
> 
>   https://lore.kernel.org/linux-mm/20221031141426.GA3994099@chaop.bj.intel.com/T/#meba4ce80709cd3afd3818b61e6419fd800287b9e
> 

Hmm, Krill and Isaku, can you confirm that TDX doesn't need this?

I think it is a generic requirement that TDX/SNP are not expecting the
host to touch a private page either from the kernel or the userspace. 

> And for SNP, the current code does the unmapping/RMP update in the same
> function:
> 
>   [PATCH RFC v8 15/56] x86/sev: Invalidate pages from the direct map when adding them to the RMP table
> 
> I'm not against splitting RMP/directmap handling, but just want to
> understand what the requirements are around that a bit better.
> 
> Does handling the #3 / RMP update / kvm_arch_post_set_memory_attributes
> stuff outside of MMU lock cause issues on TDX side? What sort of
> handling is needed in these callbacks for TDX (if anything)?
> 

No, it doesn't cause problem for TDX as TDX doesn't need such callback.

Unlike SNP, which has (1 NPT + 1 RMP) and the enforced HW check is done by RMP, TDX has
two EPT(smiliar with NPT)s (1 shared + 1 private). Converting the memory attr is achieved
by zapping the mapping from one EPT and creating the mapping in the other one in the fault
when guest access the memory. The fault GPA will carry the "SHARED" bit (!C-BIT), so
KVM knows which EPT should be chosen for populating the mapping.

I was trying to figure out what should be the proper callback and at which layer it should
sit for achieving changing memory attr for both TDX/SNP. The current callback looks a little
bit hacky. Duplicate code pieces because of locks implies the SW structure might need to be
re-considered.

> > 
> > Does SNP really need to zap the NPT mappings when changing the memory
> > attributes? (The new mappings will be created later in the fault). I don't
> > find this requirement from APM.
> 
> I don't think we've added anything specifically for SNP. Do you mean the
> generic kvm_unmap_gfn_range/kvm_flush_remote_tlbs sequence below?
> 
>   kvm_vm_ioctl_set_mem_attributes():
>     KVM_MMU_LOCK(kvm)
>     kvm_mmu_invalidate_begin()
>     ...
>     KVM_MMU_UNLOCK(kvm)
> 
>     kvm_vm_set_region_attr()  // xarray/attribute update
> 
>     ...
>     KVM_MMU_LOCK(kvm)
>     kvm_mem_attrs_changed():
>       flush |= kvm_unmap_gfn_range()
>       if (flush)
>         kvm_flush_remote_tlbs()
>     KVM_MMU_UNLOCK(kvm)
>

Yes, I was talking about the sequence above. I was confused of why changing
RMP requires a zapping-recreating flow of NPT in SNP.

> In general, when the RMPUPDATE instruction happens, the TLB entries for
> the GPAs being modified will be flushed, so subsequent nested page fault
> should be able to obtain the updated mapping based on xarray/#NPF at that
> point. In that respect *maybe* we don't need to zap the entries there.
> 
> But if the nested page fault occurs before the RMPUPDATE, I think we would
> have a race if the above sequence isn't in place to handle the unmap/flush,
> since in that case we might get a stale mapping because nothing would've
> forced a tlbflush.
> 
> There's also stuff like the UPM selftests and SEV lazy-pinning where I
> think that kvm_unmap_gfn_range() sequence is also needed. But I might be
> misunderstanding the question here.
> 

In this case, an extra tlbflush would solve? Still, the unnecessary
zapping/recreating of mapping is not promising. I understand that the way
how this patch goes is probably to minimize the changes, but it would be
nice to focus more on what is really needed in a common path and abstract
and re-factor from there.

Can you elaborate more about how the lazy-pinning unpin path is connected
with the zapping here? So that I can dig more about it.

Selftest is a minor case, guess we deal with them via enabling a switch.
E.g. a prop in debugfs.

> > If yes, can we postpone the update of the RMP table in the later fault,
> > like TDX? So that we can save this update_mem_attr x86 ops as things
> > will be solved in the SNP-specific fault handler.
> 
> Hmm, I think this would be possible. But it's nice to be able to handle
> the RMPUPDATE as part of KVM_SET_MEMORY_ATTRIBUTES, since it allows
> KVM MMU code to rely solely on xarray state and not have to query RMP
> table to check if a particular PFN needs an RMPUPDATE before mapping it
> into RMP table.
> 
> At least... it would *in theory*, if the RMPUPDATE happened under
> protection of mmu_invalidate_seq (in which case it could inherit all the
> same protections KVM MMU has around mmu_invalidate_seq/fault->mmu_seq,
> e.g. letting the guest retry the #PF if fault->mmu_seq is stale).
> 
> But currently, RMPUPDATE (via kvm_arch_post_set_memory_attributes) happens
> *after* the invalidation sequence above, so in theory a guest could fault
> on a page just after xarray state is updated, but before the RMPUPDATE has
> been done, in which case the KVM MMU code would properly map the page
> accordingly to xarray, but since RMPUPDATE wouldn't have happened yet, the
> state of the corresponding PFN in RMP table won't match the shared/private
> access type expected by the guest, so when it tries to access it it will
> get another #NPF with RMP bit set in the error code, which will get
> handled as a no-op in handle_rmp_page_fault() (patch #44) and loop like
> this until the RMPUPDATE is finally done. So it still works out, but
> maybe not keeping as much in sync with xarray state and could be.
> 

I see. rmp fault handler only deals with page size mismatch for now.

> But deferring RMPUPDATE to fault time goes in the other direction of
> that. Are there benefits/requirements for doing things this way for TDX?
> I could see it being beneficial in terms of reducing overhead for
> uneeded page-state transitions, since they are only done on-demand but
> doesn't seem like it would be that much overhead compared to some of the
> other operations being done.
> 

Besides the HW design, I guess one major purpose is to optimize the
booting time of VMs with large memory. Also, post migration can be another case.

Out of curiosity, What is the avg cost of RMUPDATE? Suppose it is an x86
instruction and not going through PSP firmware.

> > 
> > If no, guess we need a x86 ops to tell if a zapping is required.
> 
> Sorry don't think I quite understand the suggestion. What would this
> zapping be covering vs. the invalidation sequence that currently happens
> in kvm_vm_ioctl_set_mem_attributes()?

I was thinking that zapping of the mapping in EPT/NPT was required by TDX
while SNP might only need an RMP update + TLB flush. Thus, the abstraction
of the kvm_x86_ops.update_mem_attr should sit at this level. But let's
scratch this for now as I need to dig more about the lazy pinning stuff.

> 
> > 
> > Back to the lock, updating RMP table doesn't require a mutex. Taking
> > the lock is required when updating the directmap. both TDX/SNP requires
> > this update the directmap when changing memory attributes.
> 
> Is that confirmed? If so, do you have a pointer to the associated
> documentation? I'm a bit unclear on this due to above-mentioned
> discussion.
> 
> > 
> > Wouldn't it better to factor the touching directmap of kernel part out?
> 
> It actually needs to happen before the RMPUPDATE. As soon as there is a
> shared->private conversion in the RMP table for a particular PFN, then
> any access via directmap by any particular kernel thread to any PFN that
> happens to be in the same physical 2M range can cause an RMP fault on
> the host, which would be fatal. So the rmpupdate() helper in this series
> will unmap directmap entry corresponding the PFN before a shared->private
> RMPUPDATE, and restore mappings after private->shared RMPUPDATE
> 
> So we could still factor it out, but it would be something like:
> 
>   if (attr == private)
>     kvm_unmap_directmap(start, end)
>   kvm_mem_attrs_changed()
>   if (attr == shared)
>     kvm_map_directmap(start, end)
> 
> > 
> > Then you can call the x86 ops.update_mem_attr() in kvm_mem_attrs_changed().
> > And update the direct kernel mapping for both TDX/SNP in the
> > kvm_post_mem_attrs_changed().
> 
> Or, adjusting for the above logic, move the unmapping/mapping to a new
> kvm_pre_mem_attrs_changed() and kvm_post_mem_attrs_changed(), respectively.
> 
> Which seems pretty reasonable to me. Then we can:
>  - drop duplicating the kvm_for_each_memslot_in_gfn_range() walk stuff because
>    we'd just need to know what PFNs to map/unmap from directmap
>    (although we'd still need a loop around kvm_restrictedmem_get_pfn()
>    for the GFN range so not necessarily prettier)
>  - call the RMPUPDATE / corresponding TDX handling via kvm_mem_attrs_changed()
>    which brings it both under KVM MMU lock and also let's it piggyback
>    off the fault->mmu_seq handling so it doesn't get out of sync with
>    xarray during fault time.
> 

That sounds better. I am just little bit worried that update_mem_attr() will
end up as an SNP-only callback.

> But would be good to hear others' opinions on this. And also confirm
> whether TDX needs that pre/post directmap handle or not.

Yes.

> 
> Thanks!
> 
> -Mike
> 
> > 
> > > 
> > > -Mike
> > > 
> > > > 
> > > > From 7c618c1f3c236c382e64680efcbe7d8a672aa870 Mon Sep 17 00:00:00 2001
> > > > Message-Id: <7c618c1f3c236c382e64680efcbe7d8a672aa870.1679114841.git.isaku.yamahata@intel.com>
> > > > In-Reply-To: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> > > > References: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > Date: Fri, 17 Mar 2023 12:00:09 -0700
> > > > Subject: [PATCH 4/4] KVM: x86: Add 'set_mem_attr' x86 op
> > > > 
> > > > This callback will do any platform-specific handling needed for
> > > > converting pages between shared/private.
> > > > 
> > > > Originally-by: Michael Roth <michael.roth@amd.com>
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm-x86-ops.h | 1 +
> > > >  arch/x86/include/asm/kvm_host.h    | 2 ++
> > > >  arch/x86/kvm/mmu/mmu.c             | 1 +
> > > >  3 files changed, 4 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > > index dc5f18ac0bd5..956db2ee25a5 100644
> > > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > > @@ -100,6 +100,7 @@ KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> > > >  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> > > >  KVM_X86_OP(load_mmu_pgd)
> > > >  KVM_X86_OP(fault_is_private)
> > > > +KVM_X86_OP_OPTIONAL(set_mem_attr)
> > > >  KVM_X86_OP_OPTIONAL(link_private_spt)
> > > >  KVM_X86_OP_OPTIONAL(free_private_spt)
> > > >  KVM_X86_OP_OPTIONAL(split_private_spt)
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 0382d236fbf4..88e11dd3afde 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> > > >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > > >  			     int root_level);
> > > >  	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code);
> > > > +	void (*set_mem_attr)(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > +			     unsigned int attr, gfn_t start, gfn_t end);
> > > >  
> > > >  	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > > >  				void *private_spt);
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 0ec94c72895c..329333486e64 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -7908,6 +7908,7 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > > >  				    gfn_t start, gfn_t end)
> > > >  {
> > > >  	kvm_update_lpage_mixed_flag(kvm, slot, true, attrs, start, end);
> > > > +	static_call(kvm_x86_set_mem_attr)(kvm, slot, attrs, start, end);
> > > >  }
> > > >  
> > > >  void kvm_memory_attributes_create_memslot(struct kvm *kvm,
> > > > -- 
> > > > 2.25.1
> > > > 
> > > > -- 
> > > > Isaku Yamahata <isaku.yamahata@gmail.com>  
> > 
> > 

