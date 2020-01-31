Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C60914F32B
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 21:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgAaU2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 15:28:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55490 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726074AbgAaU2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 15:28:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580502510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=REszSO1YAaaLseea7FUG/A0oEFNNhe7uN3QZenLehqQ=;
        b=OUNamtYjKvptJUIdmcOknOVN3KC2BWZf11kyi5Pi0zut3roxZePOerx+4WMQJu27xgLL6+
        rMXpE1zVMAuyMN6y88etIrR/tg7jWkHZHKus6Nd5LFsmleQ2QRCxxF9+tbmEuW5Lf7iJiO
        wXPsIje/zIWNd+vJF2NyTWGnGsdjliE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-CaDpE6T8P7eUZ0HFtMXS0A-1; Fri, 31 Jan 2020 15:28:28 -0500
X-MC-Unique: CaDpE6T8P7eUZ0HFtMXS0A-1
Received: by mail-qk1-f197.google.com with SMTP id g28so4891032qkl.6
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 12:28:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=REszSO1YAaaLseea7FUG/A0oEFNNhe7uN3QZenLehqQ=;
        b=CRxwFElL0Pxa3VtZ9MyV2HAjlNXybtWZP5HNfPx4IGqnBDBNGyHUgl9qGN4D4/Z7q5
         U2ElbEYRQG6qL2KYBViYCSAc+PSLWRPgfnqGEDUJkgP/hHdCwGwEWWHxjxouL8LUCD5r
         cMLk8a+dicM1aWrevunNFvTCHMuXvYdx1sHj9vgEulsQ9O5f6VZy01TQ0m21jfJemXtu
         GmqMo1F8ZGB2/eiHc+2PCa8OLpG+9uqpfaPRIzmZ6JK62Kf0osmtoU8Kh9zwcOiP1hPS
         MJI+AUNK2hpKHuUDjD6+45TZUjqgxXfMJdW3Hs3OAe/B/BU//HCCy8wrpK/WHlc05Imx
         xBGg==
X-Gm-Message-State: APjAAAW9/ENr/SOaJsCov7PH28HwCHRg2QmmMFEs7Fs75XR//qjEoNIT
        oQH8mo+qfHHTdXNxAi7UGwV2aFQnOvjAWRz3xM+jouoNG8JaIiuUEb85YuQH5+xxKg2AW1szKu6
        w9pQOEw44s1wR
X-Received: by 2002:aed:2e02:: with SMTP id j2mr12273702qtd.370.1580502508106;
        Fri, 31 Jan 2020 12:28:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8n6AwJyBPRXQDJzG1PcplFJ92kk76/IL2PQ7U9ulOJNGzn+jVHTF/n35vGVW+g+m9ee7m8A==
X-Received: by 2002:aed:2e02:: with SMTP id j2mr12273665qtd.370.1580502507617;
        Fri, 31 Jan 2020 12:28:27 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id d22sm5501176qtp.37.2020.01.31.12.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 12:28:26 -0800 (PST)
Date:   Fri, 31 Jan 2020 15:28:24 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v3 09/21] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200131202824.GA7063@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-10-peterx@redhat.com>
 <20200121155657.GA7923@linux.intel.com>
 <20200128055005.GB662081@xz-x1>
 <20200128182402.GA18652@linux.intel.com>
 <20200131150832.GA740148@xz-x1>
 <20200131193301.GC18946@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200131193301.GC18946@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 11:33:01AM -0800, Sean Christopherson wrote:
> On Fri, Jan 31, 2020 at 10:08:32AM -0500, Peter Xu wrote:
> > On Tue, Jan 28, 2020 at 10:24:03AM -0800, Sean Christopherson wrote:
> > > On Tue, Jan 28, 2020 at 01:50:05PM +0800, Peter Xu wrote:
> > > > On Tue, Jan 21, 2020 at 07:56:57AM -0800, Sean Christopherson wrote:
> > > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > index c4d3972dcd14..ff97782b3919 100644
> > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > @@ -9584,7 +9584,15 @@ void kvm_arch_sync_events(struct kvm *kvm)
> > > > > >  	kvm_free_pit(kvm);
> > > > > >  }
> > > > > >  
> > > > > > -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > > > > +/*
> > > > > > + * If `uaddr' is specified, `*uaddr' will be returned with the
> > > > > > + * userspace address that was just allocated.  `uaddr' is only
> > > > > > + * meaningful if the function returns zero, and `uaddr' will only be
> > > > > > + * valid when with either the slots_lock or with the SRCU read lock
> > > > > > + * held.  After we release the lock, the returned `uaddr' will be invalid.
> > > > > 
> > > > > This is all incorrect.  Neither of those locks has any bearing on the
> > > > > validity of the hva.  slots_lock does as the name suggests and prevents
> > > > > concurrent writes to the memslots.  The SRCU lock ensures the implicit
> > > > > memslots lookup in kvm_clear_guest_page() won't result in a use-after-free
> > > > > due to derefencing old memslots.
> > > > > 
> > > > > Neither of those has anything to do with the userspace address, they're
> > > > > both fully tied to KVM's gfn->hva lookup.  As Paolo pointed out, KVM's
> > > > > mapping is instead tied to the lifecycle of the VM.  Note, even *that* has
> > > > > no bearing on the validity of the mapping or address as KVM only increments
> > > > > mm_count, not mm_users, i.e. guarantees the mm struct itself won't be freed
> > > > > but doesn't ensure the vmas or associated pages tables are valid.
> > > > > 
> > > > > Which is the entire point of using __copy_{to,from}_user(), as they
> > > > > gracefully handle the scenario where the process has not valid mapping
> > > > > and/or translation for the address.
> > > > 
> > > > Sorry I don't understand.
> > > > 
> > > > I do think either the slots_lock or SRCU would protect at least the
> > > > existing kvm.memslots, and if so at least the previous vm_mmap()
> > > > return value should still be valid.
> > > 
> > > Nope.  kvm->slots_lock only protects gfn->hva lookups, e.g. userspace can
> > > munmap() the range at any time.
> > 
> > Do we need to consider that?  If the userspace did this then it'll
> > corrupt itself, and imho private memory slot is not anything special
> > here comparing to the user memory slots.  For example, the userspace
> > can unmap any region after KVM_SET_USER_MEMORY_REGION ioctl even if
> > the region is filled into some of the userspace_addr of
> > kvm_userspace_memory_region, so the cached userspace_addr can be
> > invalid, then kvm_write_guest_page() can fail too with the same
> > reason.  IMHO kvm only need to make sure it handles the failure path
> > then it's perfectly fine.
> 
> Yes?  No?  My point is that your original comment's assertion that "'uaddr'
> will only be valid when with either the slots_lock or with the SRCU read
> lock held." is wrong and misleading.

Yes I'll fix that.

> 
> > > > I agree that __copy_to_user() will protect us from many cases from process
> > > > mm pov (which allows page faults inside), but again if the kvm.memslots is
> > > > changed underneath us then it's another story, IMHO, and that's why we need
> > > > either the lock or SRCU.
> > > 
> > > No, again, slots_lock and SRCU only protect gfn->hva lookups.
> > 
> > Yes, then could you further explain why do you think we don't need the
> > slot lock?  
> 
> For the same reason we don't take mmap_sem, it gains us nothing, i.e. KVM
> still has to use copy_{to,from}_user().
> 
> In the proposed __x86_set_memory_region() refactor, vmx_set_tss_addr()
> would be provided the hva of the memory region.  Since slots_lock and SRCU
> only protect gfn->hva, why would KVM take slots_lock since it already has
> the hva?

OK so you're suggesting to unlock the lock earlier to not cover
init_rmode_tss() rather than dropping the whole lock...  Yes it looks
good to me.  I think that's the major confusion I got.

> 
> > > > Or are you assuming that (1) __x86_set_memory_region() is only for the
> > > > 3 private kvm memslots, 
> > > 
> > > It's not an assumption, the entire purpose of __x86_set_memory_region()
> > > is to provide support for private KVM memslots.
> > > 
> > > > and (2) currently the kvm private memory slots will never change after VM
> > > > is created and before VM is destroyed?
> > > 
> > > No, I'm not assuming the private memslots are constant, e.g. the flow in
> > > question, vmx_set_tss_addr() is directly tied to an unprotected ioctl().
> > 
> > Why it's unprotected?
> 
> Because it doesn't need to be protected.
> 
> > Now vmx_set_tss_add() is protected by the slots lock so concurrent operation
> > is safe, also it'll return -EEXIST if called for more than once.
> 
> Returning -EEXIST is an ABI change, e.g. userspace can currently call
> KVM_SET_TSS_ADDR any number of times, it just needs to ensure proper
> serialization between calls.
> 
> If you want to change the ABI, then submit a patch to do exactly that.
> But don't bury an ABI change under the pretense that it's a bug fix.

Could you explain what do you mean by "ABI change"?

I was talking about the original code, not after applying the
patchset.  To be explicit, I mean [a] below:

int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size,
			    unsigned long *uaddr)
{
	int i, r;
	unsigned long hva;
	struct kvm_memslots *slots = kvm_memslots(kvm);
	struct kvm_memory_slot *slot, old;

	/* Called with kvm->slots_lock held.  */
	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
		return -EINVAL;

	slot = id_to_memslot(slots, id);
	if (size) {
		if (slot->npages)
			return -EEXIST;  <------------------------ [a]
        }
        ...
}

> 
> > [1]
> > 
> > > 
> > > KVM's sole responsible for vmx_set_tss_addr() is to not crash the kernel.
> > > Userspace is responsible for ensuring it doesn't break its guests, e.g.
> > > that multiple calls to KVM_SET_TSS_ADDR are properly serialized.
> > > 
> > > In the existing code, KVM ensures it doesn't crash by holding the SRCU lock
> > > for the duration of init_rmode_tss() so that the gfn->hva lookups in
> > > kvm_clear_guest_page() don't dereference a stale memslots array.
> > 
> > Here in the current master branch we have both the RCU lock and the
> > slot lock held, that's why I think we can safely remove the RCU lock
> > as long as we're still holding the slots lock.  We can't do the
> > reverse because otherwise multiple KVM_SET_TSS_ADDR could race.
> 
> Your wording is all messed up.  "we have both the RCU lock and the slot
> lock held" is wrong.

I did mess up with 2a5755bb21ee2.  We didn't take both lock here,
sorry.

> KVM holds slot_lock around __x86_set_memory_region(),
> because changing the memslots must be mutually exclusive.  It then *drops*
> slots_lock because it's done writing the memslots and grabs the SRCU lock
> in order to protect the gfn->hva lookups done by init_rmode_tss().  It
> *intentionally* drops slots_lock because writing init_rmode_tss() does not
> need to be a mutually exclusive operation, per KVM's existing ABI.
> 
> If KVM held both slots_lock and SRCU then __x86_set_memory_region() would
> deadlock on synchronize_srcu().
> 
> > > In no way
> > > does that ensure the validity of the resulting hva,
> > 
> > Yes, but as I mentioned, I don't think it's an issue to be considered
> > by KVM, otherwise we should have the same issue all over the places
> > when we fetch the cached userspace_addr from any user slots.
> 
> Huh?  Of course it's an issue that needs to be considered by KVM, e.g.
> kvm_{read,write}_guest_cached() aren't using __copy_{to,}from_user() for
> giggles.

The cache is for the GPA->HVA translation (struct gfn_to_hva_cache),
we still use __copy_{to,}from_user() upon the HVAs, no?

> 
> > > e.g. multiple calls to
> > > KVM_SET_TSS_ADDR would race to set vmx->tss_addr and so init_rmode_tss()
> > > could be operating on a stale gpa.
> > 
> > Please refer to [1].
> > 
> > I just want to double-confirm on what we're discussing now. Are you
> > sure you're suggesting that we should remove the slot lock in
> > init_rmode_tss()?  Asked because you discussed quite a bit on how the
> > slot lock should protect GPA->HVA, about concurrency and so on, then
> > I'm even more comfused...
> 
> Yes, if init_rmode_tss() is provided the hva then it does not need to
> grab srcu_read_lock(&kvm->srcu) because it can directly call
> __copy_{to,from}_user() instead of bouncing through the KVM helpers that
> translate a gfn to hva.
> 
> The code can look like this.  That being said, I've completely lost track
> of why __x86_set_memory_region() needs to provide the hva, i.e. have no
> idea if we *should* do this, or it would be better to keep the current
> code, which would be slower, but less custom.
> 
> static int init_rmode_tss(void __user *hva)
> {
> 	const void *zero_page = (const void *)__va(page_to_phys(ZERO_PAGE(0)));
> 	u16 data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
> 	int r;
> 
> 	r = __copy_to_user(hva, zero_page, PAGE_SIZE);
> 	if (r)
> 		return -EFAULT;
> 
> 	r = __copy_to_user(hva + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16))
> 	if (r)
> 		return -EFAULT;
> 
> 	hva += PAGE_SIZE;
> 	r = __copy_to_user(hva + PAGE_SIZE, zero_page, PAGE_SIZE);
> 	if (r)
> 		return -EFAULT;
> 
> 	hva += PAGE_SIZE;
> 	r = __copy_to_user(hva + PAGE_SIZE, zero_page, PAGE_SIZE);
> 	if (r)
> 		return -EFAULT;
> 
> 	data = ~0;
> 	hva += RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1;
> 	r = __copy_to_user(hva, &data, sizeof(u16))
> 	if (r)
> 		return -EFAULT;
> }
> 
> static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
> {
> 	void __user *hva;
> 
> 	if (enable_unrestricted_guest)
> 		return 0;
> 
> 	mutex_lock(&kvm->slots_lock);
> 	hva = __x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, addr,
> 				      PAGE_SIZE * 3);
> 	mutex_unlock(&kvm->slots_lock);
> 
> 	if (IS_ERR(hva))
> 		return PTR_ERR(hva);
> 
> 	to_kvm_vmx(kvm)->tss_addr = addr;
> 	return init_rmode_tss(hva);
> }
> 
> Yes, userspace can corrupt its VM by invoking KVM_SET_TSS_ADDR multiple
> times without serializing the calls, but that's already true today.

But I still don't see why we have any problem here.  Only the first
thread will get the slots_lock here and succeed this ioctl.  The rest
threads will fail with -EEXIST, no?

-- 
Peter Xu

