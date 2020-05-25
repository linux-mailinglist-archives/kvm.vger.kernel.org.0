Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEF61E11AD
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404158AbgEYP0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:26:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26759 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404026AbgEYP0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590420401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yHBg6PnKp6Y7ewCGnEB0X1+EHg5beHaOZcwWTbgUPq8=;
        b=THfCDMr618lBMB0T/iHrBLKkZG293w76vm5X+HJJEWNE5++7wn+vbBnSL0RzSjfDfccD8q
        LFPs4JfWrQW8ZGKHJzcom7ZSrXNjq/6TbzfNmJ6yyAZzJ5UX4E3EVdfgdRKZFF+NjysQOP
        QXtAKTnB9gfz9C19ehUKVYe9weCUvGA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-ev3OOTp-PHKpvMl5Sjtyiw-1; Mon, 25 May 2020 11:26:40 -0400
X-MC-Unique: ev3OOTp-PHKpvMl5Sjtyiw-1
Received: by mail-ed1-f70.google.com with SMTP id f18so7603837eds.6
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:26:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yHBg6PnKp6Y7ewCGnEB0X1+EHg5beHaOZcwWTbgUPq8=;
        b=pZ/AtHnBzhqNRlEW1FoXJeCF8GhFZfFj+V+kxb3tm8IasEi3ecntronjKCwRlYAeTn
         nI1Udie/taLpsoSz4KpIrv4RY0sxpCxMbmV65lk7+khlULA6TEsmfLUmHCRgmszXIZUA
         z3s7Ok72x3A2Yly7FNZnw7KiU6xend9SukqzQVvXewKfCEAdBIRQHa7IW9AgomSoipRu
         44tKtMeyqZd3v38giIJyi6dvCeGMvdl1hLXS0i73sRmBsQlcVfnwkmUbrMJygtm1yOeM
         IHxgg9Xe2lRvaE4Twddptn8Zal4XqvxQpZnD5pkjVBjvfUFshie1ZmDlHbrW54FMchJB
         wPvg==
X-Gm-Message-State: AOAM533qVIEDt1RB2fclLwCtUoNzutj8gIuPVDEtlPQuIiGpPd/rXBVY
        DANtEXE6ckIwlTeteRVn1bhfBpZRQ0oAE1RGER+UTWGTxDDS6R6Yy7NqYkPmT55R4Axk23hpn57
        eWuMn0KyVWwOg
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr16160577edb.156.1590420399248;
        Mon, 25 May 2020 08:26:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMIBGAc1SAeKf2++4kxqc7BH4t4BCDYHtSX1TDVqPtr5J+1qipzK2jRTRUwbqNP6YFuh1ftg==
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr16160552edb.156.1590420398965;
        Mon, 25 May 2020 08:26:38 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p5sm16523979edi.82.2020.05.25.08.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:26:38 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>, x86@kernel.org,
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
In-Reply-To: <20200522125214.31348-10-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com> <20200522125214.31348-10-kirill.shutemov@linux.intel.com>
Date:   Mon, 25 May 2020 17:26:37 +0200
Message-ID: <87367o828i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> Add infrastructure that handles protected memory extension.
>
> Arch-specific code has to provide hypercalls and define non-zero
> VM_KVM_PROTECTED.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/kvm_host.h |   4 ++
>  mm/mprotect.c            |   1 +
>  virt/kvm/kvm_main.c      | 131 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 136 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index bd0bb600f610..d7072f6d6aa0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -700,6 +700,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot);
>  
> +int kvm_protect_all_memory(struct kvm *kvm);
> +int kvm_protect_memory(struct kvm *kvm,
> +		       unsigned long gfn, unsigned long npages, bool protect);
> +
>  int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
>  			    struct page **pages, int nr_pages);
>  
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 494192ca954b..552be3b4c80a 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -505,6 +505,7 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
>  	vm_unacct_memory(charged);
>  	return error;
>  }
> +EXPORT_SYMBOL_GPL(mprotect_fixup);
>  
>  /*
>   * pkey==-1 when doing a legacy mprotect()
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 530af95efdf3..07d45da5d2aa 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -155,6 +155,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
>  static unsigned long long kvm_createvm_count;
>  static unsigned long long kvm_active_vms;
>  
> +static int protect_memory(unsigned long start, unsigned long end, bool protect);
> +
>  __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>  		unsigned long start, unsigned long end, bool blockable)
>  {
> @@ -1309,6 +1311,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	if (r)
>  		goto out_bitmap;
>  
> +	if (mem->memory_size && kvm->mem_protected) {
> +		r = protect_memory(new.userspace_addr,
> +				   new.userspace_addr + new.npages * PAGE_SIZE,
> +				   true);
> +		if (r)
> +			goto out_bitmap;
> +	}
> +
>  	if (old.dirty_bitmap && !new.dirty_bitmap)
>  		kvm_destroy_dirty_bitmap(&old);
>  	return 0;
> @@ -2652,6 +2662,127 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
>  
> +static int protect_memory(unsigned long start, unsigned long end, bool protect)
> +{
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma, *prev;
> +	int ret;
> +
> +	if (down_write_killable(&mm->mmap_sem))
> +		return -EINTR;
> +
> +	ret = -ENOMEM;
> +	vma = find_vma(current->mm, start);
> +	if (!vma)
> +		goto out;
> +
> +	ret = -EINVAL;
> +	if (vma->vm_start > start)
> +		goto out;
> +
> +	if (start > vma->vm_start)
> +		prev = vma;
> +	else
> +		prev = vma->vm_prev;
> +
> +	ret = 0;
> +	while (true) {
> +		unsigned long newflags, tmp;
> +
> +		tmp = vma->vm_end;
> +		if (tmp > end)
> +			tmp = end;
> +
> +		newflags = vma->vm_flags;
> +		if (protect)
> +			newflags |= VM_KVM_PROTECTED;
> +		else
> +			newflags &= ~VM_KVM_PROTECTED;
> +
> +		/* The VMA has been handled as part of other memslot */
> +		if (newflags == vma->vm_flags)
> +			goto next;
> +
> +		ret = mprotect_fixup(vma, &prev, start, tmp, newflags);
> +		if (ret)
> +			goto out;
> +
> +next:
> +		start = tmp;
> +		if (start < prev->vm_end)
> +			start = prev->vm_end;
> +
> +		if (start >= end)
> +			goto out;
> +
> +		vma = prev->vm_next;
> +		if (!vma || vma->vm_start != start) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +	}
> +out:
> +	up_write(&mm->mmap_sem);
> +	return ret;
> +}
> +
> +int kvm_protect_memory(struct kvm *kvm,
> +		       unsigned long gfn, unsigned long npages, bool protect)
> +{
> +	struct kvm_memory_slot *memslot;
> +	unsigned long start, end;
> +	gfn_t numpages;
> +
> +	if (!VM_KVM_PROTECTED)
> +		return -KVM_ENOSYS;
> +
> +	if (!npages)
> +		return 0;
> +
> +	memslot = gfn_to_memslot(kvm, gfn);
> +	/* Not backed by memory. It's okay. */
> +	if (!memslot)
> +		return 0;
> +
> +	start = gfn_to_hva_many(memslot, gfn, &numpages);
> +	end = start + npages * PAGE_SIZE;
> +
> +	/* XXX: Share range across memory slots? */
> +	if (WARN_ON(numpages < npages))
> +		return -EINVAL;
> +
> +	return protect_memory(start, end, protect);
> +}
> +EXPORT_SYMBOL_GPL(kvm_protect_memory);
> +
> +int kvm_protect_all_memory(struct kvm *kvm)
> +{
> +	struct kvm_memslots *slots;
> +	struct kvm_memory_slot *memslot;
> +	unsigned long start, end;
> +	int i, ret = 0;;
> +
> +	if (!VM_KVM_PROTECTED)
> +		return -KVM_ENOSYS;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	kvm->mem_protected = true;

What will happen upon guest reboot? Do we need to unprotect everything
to make sure we'll be able to boot? Also, after the reboot how will the
guest know that it is protected and needs to unprotect things? -> see my
idea about converting KVM_HC_ENABLE_MEM_PROTECTED to a stateful MSR (but
we'll likely have to reset it upon reboot anyway).

> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		slots = __kvm_memslots(kvm, i);
> +		kvm_for_each_memslot(memslot, slots) {
> +			start = memslot->userspace_addr;
> +			end = start + memslot->npages * PAGE_SIZE;
> +			ret = protect_memory(start, end, true);
> +			if (ret)
> +				goto out;
> +		}
> +	}
> +out:
> +	mutex_unlock(&kvm->slots_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_protect_all_memory);
> +
>  void kvm_sigset_activate(struct kvm_vcpu *vcpu)
>  {
>  	if (!vcpu->sigset_active)

-- 
Vitaly

