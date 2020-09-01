Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13745258524
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 03:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgIAB31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 21:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIAB30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 21:29:26 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93F9C061757;
        Mon, 31 Aug 2020 18:29:25 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id h11so2873564ilj.11;
        Mon, 31 Aug 2020 18:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oZzvSv3INTtQ3ilXht2L8FPuTMljS06aolPhjRvrCfY=;
        b=FDQ1rQhukSmRUNM8XZlkAvSqe63LJVbWQ4EF3OKcMjHhJ/5WVO6w6unpV8LiaWhvmb
         hdfyAlOhuXcfIq3DJygell1i44RaNl/xV+651kWJOzLxXT7LkzOcSHHFbBQtfKkd39Bl
         yQ5AWXHq00gXij4C8wZ5lUOft/o6xuOh192U4/2LreYGcW0mugUyDGe9W3u/0ii5I3HS
         Ty3+mXNg4i932k6iiDoqD3UXU8/H6P8MgCTcGuwLBZ/J8aAnesxk3wbzfjFWnKEKmwEM
         K8kwJ7brhcWd7B+jnVCkWZ0hJjhYU80mnub0zaOytHvkrym3yMj4XCgWCQsJhsVDmLni
         QnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oZzvSv3INTtQ3ilXht2L8FPuTMljS06aolPhjRvrCfY=;
        b=fleElEfn+tH2gi9QsjiMVdk2KFIeIs5oTiLCf/uC2OmA0ZwSqkidDrWmFalRgwJJLn
         ryQ4gYz4dhSg7WFnnGnt/zBYYT2AVaWt98fdIKUFKMjBmd73U3B7YQxVZdwhpOXOunaB
         j+qqpYaPBqN6vOvszSrW5UJ6pJLsxASWt5kYTaR2jUPZ1UI7myEQyig1I+JtbzlkrE1J
         5vH7wqv52Y9PiKM/jWhT/ISGZAOyHfeYKhBiK177iUU+zBFyW6+cCzTBOAqIriiYpbDE
         QZ1fczEYQPvNpVvJwwzOoWiJL6bNzNO94S1C5NMP7c0UdkoLNml4UJveOCDIo9qxpGkx
         B/Wg==
X-Gm-Message-State: AOAM532Y+UI3oU6xhzbRACthSEmxMM73SM2sEtghyxa6AARcWU7q2sbq
        SwC0ewBECrUHRQcndBkNpEWhwgU1pn5MTkFgTh8=
X-Google-Smtp-Source: ABdhPJzOSNzFPSecQoYsAY+49p7Kl4uFD1pNqj9fnvFVi9blc54Naj+ZT8YKDp98L/pB9UWEBLq/Ze60UN616hRySmc=
X-Received: by 2002:a92:bad9:: with SMTP id t86mr3592955ill.308.1598923764953;
 Mon, 31 Aug 2020 18:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200824101825.4106-1-jiangshanlai@gmail.com> <CAJhGHyC1Ykq5V_2nFPLRz9JmtAiQu6aw4fCKo1LO7Qwzjvfg2g@mail.gmail.com>
 <875z8zx8qs.fsf@vitty.brq.redhat.com>
In-Reply-To: <875z8zx8qs.fsf@vitty.brq.redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 1 Sep 2020 09:29:13 +0800
Message-ID: <CAJhGHyCLF4+5LV8Zwu5kczL48imKPDHJKizVd+VZwVha0U8BaQ@mail.gmail.com>
Subject: Re: [PATCH] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 31, 2020 at 9:09 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Lai Jiangshan <jiangshanlai@gmail.com> writes:
>
> > Ping @Sean Christopherson
> >
>
> Let's try 'Beetlejuice' instead :-)
>
> > On Mon, Aug 24, 2020 at 5:18 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> >>
> >> From: Lai Jiangshan <laijs@linux.alibaba.com>
> >>
> >> 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
> >> changed it without giving any reason in the changelog.
> >>
> >> In theory, the syncing is needed, and need to be fixed by reverting
> >> this part of change.
>
> Even if the original commit is not wordy enough this is hardly
> better.

Hello,
Thank you for reviewing it.

I'm sorry that when I said "reverting this part of change",
I meant "reverting this line of code". This line of code itself
is quite clear that it is not related to the original commit
according to its changelog.

> Are you seeing a particular scenario when a change in current
> vCPU's MMU requires flushing TLB entries for *other* contexts, ... (see
> below)

So I don't think the patch needs to explain this because the patch
does not change/revert anything about it.

Anyway, using a "revert" in the changelog is misleading, when it
is not really reverting the whole targeted commit. I would
remove this wording.

For the change in my patch, when kvm_mmu_get_page() gets a
page with unsync children, the host side pagetable is
unsynchronized with the guest side pagedtable, and the
guest might not issue a "flush" operation on it. It is
all about the host's emulation of the pagetable. So the host
has the responsibility to synchronize the pagetables.

Thanks
Lai

> >>
> >> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> >> ---
> >>  arch/x86/kvm/mmu/mmu.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index 4e03841f053d..9a93de921f2b 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -2468,7 +2468,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >>                 }
> >>
> >>                 if (sp->unsync_children)
> >> -                       kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> >> +                       kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>
> ... in particular, why are you reverting only this hunk? Please elaborate.
>
> >>
> >>                 __clear_sp_write_flooding_count(sp);
> >>
> >> --
> >> 2.19.1.6.gb485710b
> >>
> >
>
> --
> Vitaly
>
