Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D011E11D8
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404160AbgEYPeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404134AbgEYPeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:34:36 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ABCC05BD43
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:34:36 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id o14so21236975ljp.4
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=olnoNQxuknVW4bQuL5l9tebXpdimIfOj9TqotW4cTeA=;
        b=S5/2tK2OydDqOOPz92GXiwHcWA5BpMIaQdb6yJEiIONflcVtdqNyt15Npm9Ejh/Yib
         jqdHyq3ZArOPYiiaPcNQtpFA2tbSL6MsvhagZVCcgbzp7/4BWge00aJx/DScLdxmgVGz
         agEtZukX8gi/P9gkH/lOCz+74fS62K7kSH57gAyHOj+xqfjlqEAL3ZnAGv/DOweDoBrF
         wPSyOn/pvGQi1v0fMnCKoiZzqEoLV/3lIfn+vnjyP24ZOwvR806MoLSm53KcI47Vs6W8
         xkKXLcYCAZVWf41kjTVWjQmJtWfFK/2Z0DTutZbICKnnpsaSRo7EtowkAjR5G3TCnzO3
         VrIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=olnoNQxuknVW4bQuL5l9tebXpdimIfOj9TqotW4cTeA=;
        b=Xa2T3YyXbWACebhBa+nstrvaAru5utylZQhwnj1YAee2Xb+yKCcTO0TfymfidAZ0I4
         b0oexHorHM+mX7VrawOy8Jp2xpBGvsD/v40KrgpZ2Opw0LfqZpQvkB/P5ExdFk6SxbNK
         kriPTj72lI519ajXNCV20rcLV8RAELyJLmc4+Qzqi9iXhIp20Ax7o+VsynDmi0Gqk+1E
         aURrvsFM5GhwD9kShyYOgHjhcK8qohwvtXHkzDiamsaiofK5r7dVpUr8UW8xImxba31F
         lZT/YYatpPTlOyj0YVeTUQCoY89pxggniZ3suEXQGeYSG4IiNmBHu8VkzpgqUQJQthTu
         XxOA==
X-Gm-Message-State: AOAM533D5RXx1WsPJoINHt12CK9GK6EJKE1yAiZzzpYFgECExAHt/+V6
        sxlWsvsfWdYICkVOwUHklkDf7w==
X-Google-Smtp-Source: ABdhPJwx1Dck3qKU28qGLJSfQYnOWshmUttRmy/DfNjZQo9rEFN1phiSf4LGY2ZslMm4HFfBhPyrPg==
X-Received: by 2002:a2e:701a:: with SMTP id l26mr14906546ljc.50.1590420874530;
        Mon, 25 May 2020 08:34:34 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id r7sm5036541lfc.79.2020.05.25.08.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:34:33 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 23ECA10230F; Mon, 25 May 2020 18:34:35 +0300 (+03)
Date:   Mon, 25 May 2020 18:34:35 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 09/16] KVM: Protected memory extension
Message-ID: <20200525153435.c6mx3pjryyk4j4go@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-10-kirill.shutemov@linux.intel.com>
 <87367o828i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87367o828i.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 05:26:37PM +0200, Vitaly Kuznetsov wrote:
> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
> 
> > Add infrastructure that handles protected memory extension.
> >
> > Arch-specific code has to provide hypercalls and define non-zero
> > VM_KVM_PROTECTED.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  include/linux/kvm_host.h |   4 ++
> >  mm/mprotect.c            |   1 +
> >  virt/kvm/kvm_main.c      | 131 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 136 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index bd0bb600f610..d7072f6d6aa0 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -700,6 +700,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
> >  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> >  				   struct kvm_memory_slot *slot);
> >  
> > +int kvm_protect_all_memory(struct kvm *kvm);
> > +int kvm_protect_memory(struct kvm *kvm,
> > +		       unsigned long gfn, unsigned long npages, bool protect);
> > +
> >  int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
> >  			    struct page **pages, int nr_pages);
> >  
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 494192ca954b..552be3b4c80a 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -505,6 +505,7 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
> >  	vm_unacct_memory(charged);
> >  	return error;
> >  }
> > +EXPORT_SYMBOL_GPL(mprotect_fixup);
> >  
> >  /*
> >   * pkey==-1 when doing a legacy mprotect()
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 530af95efdf3..07d45da5d2aa 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -155,6 +155,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
> >  static unsigned long long kvm_createvm_count;
> >  static unsigned long long kvm_active_vms;
> >  
> > +static int protect_memory(unsigned long start, unsigned long end, bool protect);
> > +
> >  __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> >  		unsigned long start, unsigned long end, bool blockable)
> >  {
> > @@ -1309,6 +1311,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  	if (r)
> >  		goto out_bitmap;
> >  
> > +	if (mem->memory_size && kvm->mem_protected) {
> > +		r = protect_memory(new.userspace_addr,
> > +				   new.userspace_addr + new.npages * PAGE_SIZE,
> > +				   true);
> > +		if (r)
> > +			goto out_bitmap;
> > +	}
> > +
> >  	if (old.dirty_bitmap && !new.dirty_bitmap)
> >  		kvm_destroy_dirty_bitmap(&old);
> >  	return 0;
> > @@ -2652,6 +2662,127 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
> >  
> > +static int protect_memory(unsigned long start, unsigned long end, bool protect)
> > +{
> > +	struct mm_struct *mm = current->mm;
> > +	struct vm_area_struct *vma, *prev;
> > +	int ret;
> > +
> > +	if (down_write_killable(&mm->mmap_sem))
> > +		return -EINTR;
> > +
> > +	ret = -ENOMEM;
> > +	vma = find_vma(current->mm, start);
> > +	if (!vma)
> > +		goto out;
> > +
> > +	ret = -EINVAL;
> > +	if (vma->vm_start > start)
> > +		goto out;
> > +
> > +	if (start > vma->vm_start)
> > +		prev = vma;
> > +	else
> > +		prev = vma->vm_prev;
> > +
> > +	ret = 0;
> > +	while (true) {
> > +		unsigned long newflags, tmp;
> > +
> > +		tmp = vma->vm_end;
> > +		if (tmp > end)
> > +			tmp = end;
> > +
> > +		newflags = vma->vm_flags;
> > +		if (protect)
> > +			newflags |= VM_KVM_PROTECTED;
> > +		else
> > +			newflags &= ~VM_KVM_PROTECTED;
> > +
> > +		/* The VMA has been handled as part of other memslot */
> > +		if (newflags == vma->vm_flags)
> > +			goto next;
> > +
> > +		ret = mprotect_fixup(vma, &prev, start, tmp, newflags);
> > +		if (ret)
> > +			goto out;
> > +
> > +next:
> > +		start = tmp;
> > +		if (start < prev->vm_end)
> > +			start = prev->vm_end;
> > +
> > +		if (start >= end)
> > +			goto out;
> > +
> > +		vma = prev->vm_next;
> > +		if (!vma || vma->vm_start != start) {
> > +			ret = -ENOMEM;
> > +			goto out;
> > +		}
> > +	}
> > +out:
> > +	up_write(&mm->mmap_sem);
> > +	return ret;
> > +}
> > +
> > +int kvm_protect_memory(struct kvm *kvm,
> > +		       unsigned long gfn, unsigned long npages, bool protect)
> > +{
> > +	struct kvm_memory_slot *memslot;
> > +	unsigned long start, end;
> > +	gfn_t numpages;
> > +
> > +	if (!VM_KVM_PROTECTED)
> > +		return -KVM_ENOSYS;
> > +
> > +	if (!npages)
> > +		return 0;
> > +
> > +	memslot = gfn_to_memslot(kvm, gfn);
> > +	/* Not backed by memory. It's okay. */
> > +	if (!memslot)
> > +		return 0;
> > +
> > +	start = gfn_to_hva_many(memslot, gfn, &numpages);
> > +	end = start + npages * PAGE_SIZE;
> > +
> > +	/* XXX: Share range across memory slots? */
> > +	if (WARN_ON(numpages < npages))
> > +		return -EINVAL;
> > +
> > +	return protect_memory(start, end, protect);
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_protect_memory);
> > +
> > +int kvm_protect_all_memory(struct kvm *kvm)
> > +{
> > +	struct kvm_memslots *slots;
> > +	struct kvm_memory_slot *memslot;
> > +	unsigned long start, end;
> > +	int i, ret = 0;;
> > +
> > +	if (!VM_KVM_PROTECTED)
> > +		return -KVM_ENOSYS;
> > +
> > +	mutex_lock(&kvm->slots_lock);
> > +	kvm->mem_protected = true;
> 
> What will happen upon guest reboot? Do we need to unprotect everything
> to make sure we'll be able to boot? Also, after the reboot how will the
> guest know that it is protected and needs to unprotect things? -> see my
> idea about converting KVM_HC_ENABLE_MEM_PROTECTED to a stateful MSR (but
> we'll likely have to reset it upon reboot anyway).

That's extremely good question. I have not considered reboot. I tend to use
-no-reboot in my setup.

I'll think how to deal with reboot. I don't know how it works now to give
a good answer.

The may not be a good solution: unprotecting memory on reboot means we
expose user data. We can wipe the data before unprotecting, but we should
not wipe BIOS and anything else that is required on reboot. I donno.

> > +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > +		slots = __kvm_memslots(kvm, i);
> > +		kvm_for_each_memslot(memslot, slots) {
> > +			start = memslot->userspace_addr;
> > +			end = start + memslot->npages * PAGE_SIZE;
> > +			ret = protect_memory(start, end, true);
> > +			if (ret)
> > +				goto out;
> > +		}
> > +	}
> > +out:
> > +	mutex_unlock(&kvm->slots_lock);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_protect_all_memory);
> > +
> >  void kvm_sigset_activate(struct kvm_vcpu *vcpu)
> >  {
> >  	if (!vcpu->sigset_active)
> 
> -- 
> Vitaly
> 
> 

-- 
 Kirill A. Shutemov
