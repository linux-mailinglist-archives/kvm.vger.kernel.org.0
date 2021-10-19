Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C41434168
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 00:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhJSWdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 18:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhJSWd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 18:33:29 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E93CC061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:31:16 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t7so6264655pgl.9
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TNqWms8buUxG/jqA44+qJhAYnqd4fFLNt4zhtuGeXTE=;
        b=Gl4nSNEhpjn0aav7KlAVCR962auTultauSxUShiqk8e5HA2wOZngXCoWiyjfyXJKzX
         AYqNOYJx/vAMBWzjKhWDRX7NlZ+XNxfW+7rXvOeMoTCvafq5sIM034mm1XZEF938Nh/m
         y1qqV1QvhM2PCUXJxahSAOIo9rrfLcAB8unYztkcK84Ptqr0cvvpq09UdoQf8C57q0Ly
         mIgpI/hRGKAuQlFxKmzK4X+EcOgvV82pNJQrJ8mAr+srT/pGtunKDovVOlTtAn+L1CHw
         ktA/Rs8XfRWUDO1ukbvvdUsnELBw7OCZy6VfIlQN8zbhzLhV5M0mrns4hUSGzMawNu2a
         U3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TNqWms8buUxG/jqA44+qJhAYnqd4fFLNt4zhtuGeXTE=;
        b=S8EMQbzM26NxkgG+NWFiKqR0Co0wM78p+0tvtIR+Y6QwlKya6BD45GXJWCrBOGeapY
         44qkvuhLI7ZUWwvIcTS2+8ZNffApgBDaruNsG/2O0VnJPm8DtJp0eLhTnTFPaSHjc8GZ
         /Hn4zBulqCPyMJDh9TrowU1+J1nwhVtobiOpJrxqnd01KCVeNe5dg1aBYeHGDOA/GqEr
         h6bLY5L8YEx98KojxH65FByFxqFYXpYugtvfKxu6SvAznyuNK3Kc6zI+kPVUVXxc/xqz
         mOV3qUqUaHZR3ylupzZynoXwWz0Dy5sVEYHNMPwlzQnCc87kcrMQbwxBGK6G9PAf+53I
         8TUA==
X-Gm-Message-State: AOAM5303zhviajDZ2r9jR1//rX0kZZXey9P5uvfcGx/qOMRb6H3wWBOr
        zkjGDUF8rvV/WIZzp28DvxIBVA==
X-Google-Smtp-Source: ABdhPJwIeG7z/zS+PtmUska7dpRcnyh0lqHQXMmfhqIBmFpLNup5SmhltI+0HgJ7YJLLHXl+YBn4Eg==
X-Received: by 2002:a63:f306:: with SMTP id l6mr30167959pgh.72.1634682675889;
        Tue, 19 Oct 2021 15:31:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id on17sm3844560pjb.47.2021.10.19.15.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 15:31:15 -0700 (PDT)
Date:   Tue, 19 Oct 2021 22:31:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/13] KVM: x86: Cache total page count to avoid
 traversing the memslot array
Message-ID: <YW9HL3FOkOk56I5g@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <d07f07cdd545ab1a495a9a0da06e43ad97c069a2.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9Fi128rYxiF1v3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW9Fi128rYxiF1v3@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > 
> > There is no point in recalculating from scratch the total number of pages
> > in all memslots each time a memslot is created or deleted.
> > 
> > Just cache the value and update it accordingly on each such operation so
> > the code doesn't need to traverse the whole memslot array each time.
> > 
> > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > ---
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 28ef14155726..65fdf27b9423 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11609,9 +11609,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >  				const struct kvm_memory_slot *new,
> >  				enum kvm_mr_change change)
> >  {
> > -	if (!kvm->arch.n_requested_mmu_pages)
> > -		kvm_mmu_change_mmu_pages(kvm,
> > -				kvm_mmu_calculate_default_mmu_pages(kvm));
> > +	if (change == KVM_MR_CREATE)
> > +		kvm->arch.n_memslots_pages += new->npages;
> > +	else if (change == KVM_MR_DELETE) {
> > +		WARN_ON(kvm->arch.n_memslots_pages < old->npages);
> > +		kvm->arch.n_memslots_pages -= old->npages;
> > +	}
> > +
> > +	if (!kvm->arch.n_requested_mmu_pages) {
> 
> Hmm, once n_requested_mmu_pages is set it can't be unset.  That means this can be
> further optimized to skip avoid taking mmu_lock on flags-only changes (and
> memslot movement).  E.g.
> 
> 	if (!kvm->arch.n_requested_mmu_pages &&
> 	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
> 
> 	}
> 
> It's a little risky, but kvm_vm_ioctl_set_nr_mmu_pages() would need to be modified
> to allow clearing n_requested_mmu_pages and it already takes slots_lock, so IMO
> it's ok to force kvm_vm_ioctl_set_nr_mmu_pages() to recalculate pages if it wants
> to allow reverting back to the default.

Doh, and then I read patch 2...

I would swap the order of patch 2 and patch 1, that way the optimization patch is
super simple, and you don't end up reworking a bunch of code that was added in the
immediately preceding patch.  E.g. as a first patch

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..f3b1aed08566 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11609,7 +11609,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
                                const struct kvm_memory_slot *new,
                                enum kvm_mr_change change)
 {
-       if (!kvm->arch.n_requested_mmu_pages)
+       if (!kvm->arch.n_requested_mmu_pages &&
+           (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
                kvm_mmu_change_mmu_pages(kvm,
                                kvm_mmu_calculate_default_mmu_pages(kvm));



