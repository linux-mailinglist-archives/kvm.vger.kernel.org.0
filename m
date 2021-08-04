Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F71C3DFBE2
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 09:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhHDHRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 03:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbhHDHRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 03:17:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742E9C061798
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 00:17:09 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l18so1056770wrv.5
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 00:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XNEs/6yr9b8hBQJj2GN/2tEZCeGoJUsw90alOL/69is=;
        b=MRfa7s2FlqWOZN1LdWG9uuA2LDK4JWa35Hl4QjcgjFTI6pryHaQWkcpUdTW9ls6cUh
         wU/tM9FUyC5q4Hs7TpxT5/kRxdkcJUp0QgLu0QMLU/TgjjYbGEPjBeVJCu2aybz6/x96
         P9wN8SKOi+yNj2hmcKkKnxLElr+ajPmy36P9Ldz2zFvolMi/qlmLZ2MF8bCYsvWHjVyW
         ASZLShSWvUGBBklIwdSJ+VhMMOhjx90ZrUk96mRak3VNf9bIg5yTfwgrahOH9QD/GWAr
         bICzY7dttw78c8vG73H8QPTvHElx6JB5fryzSD0RL5eoWWk/sogoyswO5lF/haQ8gwu1
         A8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XNEs/6yr9b8hBQJj2GN/2tEZCeGoJUsw90alOL/69is=;
        b=nClqoa4+U1dF2R2ByIyKW9CZt0Se3GclEXEQZa8nDJ9W3ZCtKLWpxZ53xPLtzS+9CV
         Kt+7C9mlBYTsfkK8xNKN/+7CsDj1CLTHZjYOCNhf+PxHPJg0QGun7pY2ku9xZu2u8CkC
         Pahr7zqD5xjNHB03Z4w9k4qV1ViIggZzc1XhRRUMP0fQItI1eXDetPDh5hGsxRK4cKZA
         uxTbADabq5X/2rZbTUMunYVLxAJtUUJFvVRl2Zh4AjF9dP4pgwHYe4GXsxu3xQm6PEtG
         x6xRKrOtWkZGBOTGmaREhXWl0QHxGhy+Hk6sT5CSSWUr4oC6XRYq+9sKnZPagXQE4sPF
         +4xw==
X-Gm-Message-State: AOAM531y/U/8/z2pg+hiA2z5gfYUSAl+QsGRmSpjupB58Tuj3Q5Tuezd
        yGmAUgEXAqM6rGLj9M6fvkEfiKBQKBkoBFKk591w/g==
X-Google-Smtp-Source: ABdhPJziyxjW3/zAe6HvyWFtZ1PxzUYuOaOmP44elbzWWY60sj71QIHYVTXI1bP8qaCoQecHSM5/k92hfV7UFYOU8Ew=
X-Received: by 2002:a5d:640f:: with SMTP id z15mr27704351wru.325.1628061427914;
 Wed, 04 Aug 2021 00:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210727055450.2742868-1-anup.patel@wdc.com> <20210727055450.2742868-12-anup.patel@wdc.com>
 <38734ad1008a46169dcd89e1ded9ac62@huawei.com>
In-Reply-To: <38734ad1008a46169dcd89e1ded9ac62@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 4 Aug 2021 12:46:20 +0530
Message-ID: <CAAhSdy2jCQQScw9KMwHy-c7Mgkaq5xB95qmjypJEYbb+0q3_Tg@mail.gmail.com>
Subject: Re: [PATCH v19 11/17] RISC-V: KVM: Implement MMU notifiers
To:     "limingwang (A)" <limingwang@huawei.com>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 3, 2021 at 6:49 PM limingwang (A) <limingwang@huawei.com> wrote:
>
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c index
> > fa9a4f9b9542..4b294113c63b 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -300,7 +300,8 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t
> > addr,
> >       }
> >  }
> >
> > -static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
> > +static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
> > +                            gpa_t size, bool may_block)
> >  {
> >       int ret;
> >       pte_t *ptep;
> > @@ -325,6 +326,13 @@ static void stage2_unmap_range(struct kvm *kvm,
> > gpa_t start, gpa_t size)
> >
> >  next:
> >               addr += page_size;
> > +
> > +             /*
> > +              * If the range is too large, release the kvm->mmu_lock
> > +              * to prevent starvation and lockup detector warnings.
> > +              */
> > +             if (may_block && addr < end)
> > +                     cond_resched_lock(&kvm->mmu_lock);
> >       }
> >  }
> >
> > @@ -405,7 +413,6 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa,
> > phys_addr_t hpa,
> >  out:
> >       stage2_cache_flush(&pcache);
> >       return ret;
> > -
> >  }
> >
> >  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm, @@
> > -547,7 +554,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >       spin_lock(&kvm->mmu_lock);
> >       if (ret)
> >               stage2_unmap_range(kvm, mem->guest_phys_addr,
> > -                                mem->memory_size);
> > +                                mem->memory_size, false);
> >       spin_unlock(&kvm->mmu_lock);
> >
> >  out:
> > @@ -555,6 +562,73 @@ int kvm_arch_prepare_memory_region(struct kvm
> > *kvm,
> >       return ret;
> >  }
> >
> > +bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> > +{
> > +     if (!kvm->arch.pgd)
> > +             return 0;
> > +
> > +     stage2_unmap_range(kvm, range->start << PAGE_SHIFT,
> > +                        (range->end - range->start) << PAGE_SHIFT,
> > +                        range->may_block);
> > +     return 0;
> > +}
> > +
> > +bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range) {
> > +     int ret;
> > +     kvm_pfn_t pfn = pte_pfn(range->pte);
> > +
> > +     if (!kvm->arch.pgd)
> > +             return 0;
> > +
> > +     WARN_ON(range->end - range->start != 1);
> > +
> > +     ret = stage2_map_page(kvm, NULL, range->start << PAGE_SHIFT,
> > +                           __pfn_to_phys(pfn), PAGE_SIZE, true, true);
> > +     if (ret) {
> > +             kvm_err("Failed to map stage2 page (error %d)\n", ret);
> > +             return 1;
> > +     }
>
> Hi, Anup
>
> I think that it is not appropriate to add kvm_err here, because stage2_set_pte function
> may apply for memory based on the pcache parameter. If the value of pcache is NULL,
> stage2_set_pte function considers that there is not enough memory and here an invalid
> error log is generated.
>
> As an example, this error log is printed when a VM is migrating. But finally the VM migration
> is successful. And if the kvm_err is added to the same position in the ARM architecture, the
> same error log is also printed.

Okay, I have converted kvm_err() to kvm_debug(). In the future, we can totally
remove it as well.

Please try riscv_kvm_v20 branch at:
https://github.com/avpatel/linux.git

Regards,
Anup

>
> Mingwang
>
> > +     return 0;
> > +}
> > +
>
