Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC788445BA3
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 22:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhKDVau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 17:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhKDVau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 17:30:50 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F18C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 14:28:11 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id d70so7588770iof.7
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 14:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kT59fOFXGdqG57cxSFiBCbx9dcYetqnRywW1gdZNmeY=;
        b=gT4nzQq0x89i6Vp5dNWtSZrRbMe0W3qbbXwW9NXWgaRs8fYbXvHzdlEGUK48g0ajas
         uHVv10bVNkjhWr3B3MYTi44+qGBwBfoBwhj+2jrlWAsr2slc13bc4BseaXy2AoLJs6t8
         xRBsjkLiRiH+rEZC9bjYDRvB0cKfRmGxlddQQ74lKlIH3DSIbhZURrg/4JSes8eUaatv
         4YcLz57IesgJy0I2f7nby9V0UuPZTikaQqcNEzddlw13/ibFXy00E0dEkzMok1oNoZqt
         ZDIYGh1maMM5k3AvqVuUpAr6S+JkIrJwFta52d8TDhA2FBg5X1Xits9o/XjdmWUTRl4X
         pAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kT59fOFXGdqG57cxSFiBCbx9dcYetqnRywW1gdZNmeY=;
        b=P1rOAyQeDZn42xGgzOWf3/kKQT0gBmwJ3r+Nji7A+PzL7AIqgsGVzCZxXbLRTHPBxD
         ETtVyexxHIRBjuWNjRIWbx6dK5t4moBz58bhNsgab98PFF6Q5Zb1QKRUB1+xd6EMjpbz
         EWYTSxNcg4/GNG1DSwwp0BChrsQnLPPhCPH3ycriSnCvXwmTffZH3PBMdgJAb2CgcBcK
         /gaSc6aTNKtag+MMImBkoIL777HEUUvcNaZ6Sb5YrHaBsusT5oE9zmn4+N2pxkjkKFgn
         SzKnQFRwmNV91RGJHKQQvmIPC9ndHIzrksWO8ereOwTxJrHQ10x1fiGb5UMMGNvlIkao
         Z84Q==
X-Gm-Message-State: AOAM532KcFEbYG/hhcwfQwDnETAw/kTZkwmBh5RXHR8ejg5xPOzAWRYj
        jNwO2z9Z/QhOoxQZmkeGXulD8+nPkAqt44oF7wBxNw==
X-Google-Smtp-Source: ABdhPJyMIoxuukzQc6rukS1CsN0VzOsX5g2manzJn1KGK69DmvdVJ1f5vqR2wNyFb/XiaX/LmgNI1ppfR5uwGseVoTo=
X-Received: by 2002:a05:6602:1612:: with SMTP id x18mr282554iow.37.1636061290880;
 Thu, 04 Nov 2021 14:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com> <20211104002531.1176691-2-seanjc@google.com>
In-Reply-To: <20211104002531.1176691-2-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 4 Nov 2021 14:27:59 -0700
Message-ID: <CANgfPd-uuPFjAHk5kVNom2Qs=UU_GX6CQ0xDLg1h_iL8t8S2aQ@mail.gmail.com>
Subject: Re: [PATCH v5.5 01/30] KVM: Ensure local memslot copies operate on
 up-to-date arch-specific data
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 3, 2021 at 5:26 PM Sean Christopherson <seanjc@google.com> wrote:
>
> When modifying memslots, snapshot the "old" memslot and copy it to the
> "new" memslot's arch data after (re)acquiring slots_arch_lock.  x86 can
> change a memslot's arch data while memslot updates are in-progress so
> long as it holds slots_arch_lock, thus snapshotting a memslot without
> holding the lock can result in the consumption of stale data.
>
> Fixes: b10a038e84d1 ("KVM: mmu: Add slots_arch_lock for memslot arch fields")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 47 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 16 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3f6d450355f0..99e69375c4c9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1531,11 +1531,10 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>
>  static int kvm_set_memslot(struct kvm *kvm,
>                            const struct kvm_userspace_memory_region *mem,
> -                          struct kvm_memory_slot *old,
>                            struct kvm_memory_slot *new, int as_id,
>                            enum kvm_mr_change change)
>  {
> -       struct kvm_memory_slot *slot;
> +       struct kvm_memory_slot *slot, old;
>         struct kvm_memslots *slots;
>         int r;
>
> @@ -1566,7 +1565,7 @@ static int kvm_set_memslot(struct kvm *kvm,
>                  * Note, the INVALID flag needs to be in the appropriate entry
>                  * in the freshly allocated memslots, not in @old or @new.
>                  */
> -               slot = id_to_memslot(slots, old->id);
> +               slot = id_to_memslot(slots, new->id);

Since new is guaranteed to have the same id as old (at least prior to
this change) this is a no-op change, so no problem here.
This could be a separate commit which would have no functional change
but only worth extracting if you send a v2.

>                 slot->flags |= KVM_MEMSLOT_INVALID;
>
>                 /*
> @@ -1597,6 +1596,26 @@ static int kvm_set_memslot(struct kvm *kvm,
>                 kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
>         }
>
> +       /*
> +        * Make a full copy of the old memslot, the pointer will become stale
> +        * when the memslots are re-sorted by update_memslots(), and the old
> +        * memslot needs to be referenced after calling update_memslots(), e.g.
> +        * to free its resources and for arch specific behavior.  This needs to
> +        * happen *after* (re)acquiring slots_arch_lock.
> +        */
> +       slot = id_to_memslot(slots, new->id);
> +       if (slot) {
> +               old = *slot;
> +       } else {
> +               WARN_ON_ONCE(change != KVM_MR_CREATE);
> +               memset(&old, 0, sizeof(old));
> +               old.id = new->id;
> +               old.as_id = as_id;
> +       }
> +
> +       /* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
> +       memcpy(&new->arch, &old.arch, sizeof(old.arch));
> +

Is new->arch not initialized before this function is called? Does this
need to be here, or could it be moved above into the first branch of
the if statement?
Oh I see you removed the memset below and replaced it with this. I
think this is fine, but it might be easier to reason about if we left
the memset and moved the memcopy into the if.
No point in doing a memcpy of zeros here.

>         r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
>         if (r)
>                 goto out_slots;
> @@ -1604,14 +1623,18 @@ static int kvm_set_memslot(struct kvm *kvm,
>         update_memslots(slots, new, change);
>         slots = install_new_memslots(kvm, as_id, slots);
>
> -       kvm_arch_commit_memory_region(kvm, mem, old, new, change);
> +       kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
> +
> +       /* Free the old memslot's metadata.  Note, this is the full copy!!! */
> +       if (change == KVM_MR_DELETE)
> +               kvm_free_memslot(kvm, &old);
>
>         kvfree(slots);
>         return 0;
>
>  out_slots:
>         if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> -               slot = id_to_memslot(slots, old->id);
> +               slot = id_to_memslot(slots, new->id);
>                 slot->flags &= ~KVM_MEMSLOT_INVALID;
>                 slots = install_new_memslots(kvm, as_id, slots);
>         } else {
> @@ -1626,7 +1649,6 @@ static int kvm_delete_memslot(struct kvm *kvm,
>                               struct kvm_memory_slot *old, int as_id)
>  {
>         struct kvm_memory_slot new;
> -       int r;
>
>         if (!old->npages)
>                 return -EINVAL;
> @@ -1639,12 +1661,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
>          */
>         new.as_id = as_id;
>
> -       r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
> -       if (r)
> -               return r;
> -
> -       kvm_free_memslot(kvm, old);
> -       return 0;
> +       return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
>  }
>
>  /*
> @@ -1718,7 +1735,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>         if (!old.npages) {
>                 change = KVM_MR_CREATE;
>                 new.dirty_bitmap = NULL;
> -               memset(&new.arch, 0, sizeof(new.arch));
>         } else { /* Modify an existing slot. */
>                 if ((new.userspace_addr != old.userspace_addr) ||
>                     (new.npages != old.npages) ||
> @@ -1732,9 +1748,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>                 else /* Nothing to change. */
>                         return 0;
>
> -               /* Copy dirty_bitmap and arch from the current memslot. */
> +               /* Copy dirty_bitmap from the current memslot. */
>                 new.dirty_bitmap = old.dirty_bitmap;
> -               memcpy(&new.arch, &old.arch, sizeof(new.arch));
>         }
>
>         if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
> @@ -1760,7 +1775,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>                         bitmap_set(new.dirty_bitmap, 0, new.npages);
>         }
>
> -       r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
> +       r = kvm_set_memslot(kvm, mem, &new, as_id, change);
>         if (r)
>                 goto out_bitmap;
>
> --
> 2.33.1.1089.g2158813163f-goog
>
