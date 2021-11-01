Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C80444236F
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhKAWbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhKAWbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 18:31:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9DCC061714
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 15:29:11 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t11so12913838plq.11
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RrU1MJ/4uTu6+T3pfv3zx2EhdvwG5+grtllrLBzle4M=;
        b=AUeK79xZFdmdz+B6CkAt+NHLg98ZBphv0hzwKyzSt2AUOswoZQMqHBGJzpzBo/VOhP
         Q2BxGvSzmBHCKBTfFJQ7PlZK1QBY/Pv2hVx1bzGtv5nkxczXoMP5kSZjGpYMRsRTvFa7
         Ml5dMTuo8aFWHd9y8hHn9d5DdNccH9O46J1YE+2ptWvQwcW4jux48GrYDqv2TCdeFsj2
         r0EfDFT2g4AChRGZy8K082hvpbbSZG/Eb5nehm8AKYvRcv3DAR5Bfa9cYeQq+qSnwSRk
         kU1JDVbmQDvlcxqERU4tK9mmPMfTKrpA1mSgMK3uSRUXXEofWwoM+iWZMuLJ2elJqn8E
         xCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RrU1MJ/4uTu6+T3pfv3zx2EhdvwG5+grtllrLBzle4M=;
        b=zPwJdpwGU5+IDPSmt+DxjbM9jTtx3DaptqixUv6vQ/9gIJB/Lmr5FQyZH0uLhZ8DYu
         ymQtWVkjIFLn883AvmnIqsepO3CerKhk7ATtC5TgUdni1rre5bRM5c/amMi9RJt7bRqS
         DrfaDogASgRmzAgfyKIuxyW7mLnRF6SCgpMIU5Mn8x7zJ016rncO2OGbijMiGhQowz3a
         aifzg+bRipY2zMarRkfqdYhe5DvJ6Ah8gi87GtqvnnUNDjd3kMMi0p6zSd+V/ePz81OA
         eY74GIztDlCIgXD11OBjWIHZsGXDo8XOEB0ntcRtwLk6qnQ41WXQ3/IOc4gBNMs3DuCN
         coCw==
X-Gm-Message-State: AOAM5331FLR6GXZvN4F2/rj52tTW2UHZeZ+/16UXYdNoimROjO2fHWLs
        su8AVQWj3a0Z1Zz9CEL+PCEhoA==
X-Google-Smtp-Source: ABdhPJwWOAavFsgRVBIr8Oy0QFnvzRUVFNT585YkHtLNIJzBlgOrcYPsCeJXblrSZiJZc+cYROvb0g==
X-Received: by 2002:a17:90a:ae18:: with SMTP id t24mr1997276pjq.92.1635805750337;
        Mon, 01 Nov 2021 15:29:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g4sm5404655pfj.67.2021.11.01.15.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:29:09 -0700 (PDT)
Date:   Mon, 1 Nov 2021 22:29:06 +0000
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
Message-ID: <YYBqMipZT9qcwDMt@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <d07f07cdd545ab1a495a9a0da06e43ad97c069a2.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9Fi128rYxiF1v3@google.com>
 <e618edce-b310-6d9a-3860-d7f4d8c0d98f@maciej.szmigiero.name>
 <YXBnn6ZaXbaqKvOo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXBnn6ZaXbaqKvOo@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Sean Christopherson wrote:
> On Wed, Oct 20, 2021, Maciej S. Szmigiero wrote:
> > On 20.10.2021 00:24, Sean Christopherson wrote:
> > > E.g. the whole thing can be
> > > 
> > > 	if (!kvm->arch.n_requested_mmu_pages &&
> > > 	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
> > > 		unsigned long nr_mmu_pages;
> > > 
> > > 		if (change == KVM_MR_CREATE) {
> > > 			kvm->arch.n_memslots_pages += new->npages;
> > > 		} else {
> > > 			WARN_ON(kvm->arch.n_memslots_pages < old->npages);
> > > 			kvm->arch.n_memslots_pages -= old->npages;
> > > 		}
> > > 
> > > 		nr_mmu_pages = (unsigned long)kvm->arch.n_memslots_pages;
> > > 		nr_mmu_pages *= (KVM_PERMILLE_MMU_PAGES / 1000);
> > 
> > The above line will set nr_mmu_pages to zero since KVM_PERMILLE_MMU_PAGES
> > is 20, so when integer-divided by 1000 will result in a multiplication
> > coefficient of zero.
> 
> Ugh, math.  And thus do_div() to avoid the whole 64-bit divide issue on 32-bit KVM.
> Bummer.

I was revisiting this today because (a) simply making n_memslots_pages a u64 doesn't
cleanly handle the case where the resulting nr_mmu_pages would wrap, (b) any fix
in that are should really go in a separate patch to fix
kvm_mmu_calculate_default_mmu_pages() and then carry that behavior forward

But as I dove deeper (and deeper), I came to the conclusion that supporting a
total number of memslot pages that doesn't fit in an unsigned long is a waste of
our time.  With a 32-bit kernel, userspace can at most address 3gb of virtual
memory, whereas wrapping the total number of pages would require 4tb+ of guest
physical memory.  Even with x86's second address space for SMM, that means userspace
would need to alias all of guest memory more than one _thousand_ times.  And on
older hardware with MAXPHYADDR < 43, the guest couldn't actually access any of those
aliases even if userspace lied about guest.MAXPHYADDR.

So unless I'm missing something, or PPC or MIPS has some crazy way for a 32-bit
host to support 4TB of guest memory, my vote would be to explicitly disallow
creating more memslot pages than can fit in an unsigned long.  Then x86 KVM could
reuse the cache nr_memslot_pages and x86's MMU wouldn't have to update a big pile
of code to support a scenario that practically speaking is useless.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 72b329e82089..acabdbdef5cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -552,6 +552,7 @@ struct kvm {
         */
        struct mutex slots_arch_lock;
        struct mm_struct *mm; /* userspace tied to this vm */
+       unsigned long nr_memslot_pages;
        struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
        struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8bf4b89cfa03..c63fc5c05322 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1567,6 +1567,15 @@ static void kvm_commit_memory_region(struct kvm *kvm,
                                     const struct kvm_memory_slot *new,
                                     enum kvm_mr_change change)
 {
+       /*
+        * Update the total number of memslot pages before calling the arch
+        * hook so that architectures can consume the result directly.
+        */
+       if (change == KVM_MR_DELETE)
+               kvm->nr_memslot_pages -= old->npages;
+       else if (change == KVM_MR_CREATE)
+               kvm->nr_memslot_pages += new->npages;
+
        kvm_arch_commit_memory_region(kvm, old, new, change);

        /*
@@ -1738,6 +1747,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
                if (!old || !old->npages)
                        return -EINVAL;

+               if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
+                       return -EIO;
+
                memset(&new, 0, sizeof(new));
                new.id = id;
                new.as_id = as_id;
@@ -1756,6 +1768,13 @@ int __kvm_set_memory_region(struct kvm *kvm,

        if (!old || !old->npages) {
                change = KVM_MR_CREATE;
+
+               /*
+                * To simplify KVM internals, the total number of pages across
+                * all memslots must fit in an unsigned long.
+                */
+               if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
+                       return -EINVAL;
        } else { /* Modify an existing slot. */
                if ((new.userspace_addr != old->userspace_addr) ||
                    (new.npages != old->npages) ||
