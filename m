Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E51C35D035
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 20:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244825AbhDLSW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 14:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236635AbhDLSW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 14:22:28 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288B1C06174A
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 11:22:09 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id n4so11848983ili.8
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 11:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pnS66VMnQJOfrQyl2K7TCo3s3dpgaNmmTPqQ0SzKz4s=;
        b=TqcrGz6KegN4pgqHPFivO3yGcoeZ9JJB6yZiEM5mAH0qxvLsR4SaGHWo0U+elcVTyI
         TSSKliuOOFqi3UJxhDqG7QSKqqO/9Vvx1mue/2PCnaDTlLpGSemF80v0dI143RexXv1j
         ady1yIvG8Zizv9go+vd2t3SqJ92h6aaa1kxViJfcAfqiAEyMtWO35CgIFHGfUqypuSgM
         LLYaLHfLyGEFQu/xArIC8HCiX4eCJnWv2LWr6FQcgDHl0ExNXTwCLJk9L+/GcXuLEeWu
         JJX+qm7lowNyE1UF6Sf229fqH1kvV8QIxPiwJy9vRjN//S/A0Do6mlTzid3FhRpUUW/d
         6YgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pnS66VMnQJOfrQyl2K7TCo3s3dpgaNmmTPqQ0SzKz4s=;
        b=irNQs65wh3enm5gC6UzX0+nXWeWeNkoNRP5wbaqKDUeIe0TtOtSGNDsqWkyWQhWVMB
         GIs12LqKNfq7Xz7kyX2kHcexGyF1tlF6AJ7QdxyVzx/VOJtyZ4xE/2V21TOz2jL5Q2oA
         Az2zx5EMS78QVA3lFQmigImPQytBgJNTepd7iZLZoiCAGNZLCYwa24I3jUk5wb9FKKCZ
         KX/sDduA4CoFWhYMGzhzRFHabHes8ikF3BAvcfFgmM+0qOHqSW9Sa2Hyod9cnNe3U5pr
         vrMTKUC15l3RW04IVK42rU/3Xu97oXZ2zTZXGOLLOYtnM8QBOyTPvUrU3UryKQypOo1j
         ZI4Q==
X-Gm-Message-State: AOAM531KlOEUzY+fBVTy2bJtZBLNOXbqLIw309WViIRAdBBBki0IuTDa
        hhsQlC03O/Opw/ty6p/r1M9dsb+u+qcL+vousd2sow==
X-Google-Smtp-Source: ABdhPJwm+p1wkbZpFs/xEL+3HaD8HlLDy1XD8ohjBf6jJHtLg6V4pd8T8YN5xkFghqM9wK3gH/5Tb+0+prv0uWNCQzw=
X-Received: by 2002:a05:6e02:1a49:: with SMTP id u9mr2895809ilv.306.1618251728283;
 Mon, 12 Apr 2021 11:22:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com> <20210401233736.638171-10-bgardon@google.com>
 <4fc5960f-0b64-1cf5-d2c1-080d82d226a0@redhat.com>
In-Reply-To: <4fc5960f-0b64-1cf5-d2c1-080d82d226a0@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 12 Apr 2021 11:21:57 -0700
Message-ID: <CANgfPd-kYQgwdtm5uamYrPhq_V6DkocZXTq9iKzbfJaWcLy3Lw@mail.gmail.com>
Subject: Re: [PATCH v2 09/13] KVM: x86/mmu: Allow zap gfn range to operate
 under the mmu read lock
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 2, 2021 at 12:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/04/21 01:37, Ben Gardon wrote:
> > +void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > +                       bool shared)
> >   {
> >       gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> >
> > -     lockdep_assert_held_write(&kvm->mmu_lock);
> > +     kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> >
> >       if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
> >               return;
> > @@ -81,7 +92,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
> >       list_del_rcu(&root->link);
> >       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> >
> > -     zap_gfn_range(kvm, root, 0, max_gfn, false, false);
> > +     zap_gfn_range(kvm, root, 0, max_gfn, false, false, shared);
> >
> >       call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>
> Instead of patch 13, would it make sense to delay the zap_gfn_range and
> call_rcu to a work item (either unconditionally, or only if
> shared==false)?  Then the zap_gfn_range would be able to yield and take
> the mmu_lock for read, similar to kvm_tdp_mmu_zap_invalidated_roots.
>
> If done unconditionally, this would also allow removing the "shared"
> argument to kvm_tdp_mmu_put_root, tdp_mmu_next_root and
> for_each_tdp_mmu_root_yield_safe, so I would place that change before
> this patch.
>
> Paolo
>

I tried that and it created problems. I believe the issue was that on
VM teardown memslots would be freed and the memory reallocated before
the root was torn down, resulting in a use-after free from
mark_pfn_dirty. Perhaps this could be resolved by forcing memslot
changes to wait until that work item was processed before returning. I
can look into it but I suspect there will be a lot of "gotchas"
involved.
