Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCCA81BA7F
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfEMQA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbfEMQA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:00:28 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6237A2189E
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557763226;
        bh=4bcLIFwRGdrxUSdLyYcDKBhiisD8Iba6LGdB6inApCI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AD3U09r7iadGQx9xKbeGtVco8OzKuPg56V0gCnVoJ/QhP1NKeI/l6NioJQod0RAw5
         efv1W0cVsndHHYOXwwIWp0FMOC+k8HgKKyi06hYNpjbnnmrFVtYZKLTdjORICG+SZu
         mNQUApnmoJ+bqhQLGnlM/Z/jq/ZnhSyCSOdz5iAQ=
Received: by mail-wm1-f52.google.com with SMTP id f204so8930740wme.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 09:00:26 -0700 (PDT)
X-Gm-Message-State: APjAAAWxb3IiaSwGC4yaRTyJpnIfJAo4gCTEWdQkhwaTo9PpGpuw+Fdx
        HawMktkp8VFwUakMVOriRbskNzlqDQI+CB8nhf8YKw==
X-Google-Smtp-Source: APXvYqyd+g/+4DZb2reYmQhd8ogKBbEXXDmgoGo0ruNMmraoSXzfuFYqbpdMTwD2u4rjVZ6Pb2GGB/07OeDLopopDBs=
X-Received: by 2002:a1c:eb18:: with SMTP id j24mr17012407wmh.32.1557763224812;
 Mon, 13 May 2019 09:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-20-git-send-email-alexandre.chartre@oracle.com> <a9198e28-abe1-b980-597e-2d82273a2c17@intel.com>
In-Reply-To: <a9198e28-abe1-b980-597e-2d82273a2c17@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 May 2019 09:00:13 -0700
X-Gmail-Original-Message-ID: <CALCETrXYW-CfixanL3Wk5v_5Ex7WMe+7POV0VfBVHujfb6cvtQ@mail.gmail.com>
Message-ID: <CALCETrXYW-CfixanL3Wk5v_5Ex7WMe+7POV0VfBVHujfb6cvtQ@mail.gmail.com>
Subject: Re: [RFC KVM 19/27] kvm/isolation: initialize the KVM page table with
 core mappings
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 8:50 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> > +     /*
> > +      * Copy the mapping for all the kernel text. We copy at the PMD
> > +      * level since the PUD is shared with the module mapping space.
> > +      */
> > +     rv = kvm_copy_mapping((void *)__START_KERNEL_map, KERNEL_IMAGE_SIZE,
> > +          PGT_LEVEL_PMD);
> > +     if (rv)
> > +             goto out_uninit_page_table;
>
> Could you double-check this?  We (I) have had some repeated confusion
> with the PTI code and kernel text vs. kernel data vs. __init.
> KERNEL_IMAGE_SIZE looks to be 512MB which is quite a bit bigger than
> kernel text.
>
> > +     /*
> > +      * Copy the mapping for cpu_entry_area and %esp fixup stacks
> > +      * (this is based on the PTI userland address space, but probably
> > +      * not needed because the KVM address space is not directly
> > +      * enterered from userspace). They can both be copied at the P4D
> > +      * level since they each have a dedicated P4D entry.
> > +      */
> > +     rv = kvm_copy_mapping((void *)CPU_ENTRY_AREA_PER_CPU, P4D_SIZE,
> > +          PGT_LEVEL_P4D);
> > +     if (rv)
> > +             goto out_uninit_page_table;
>
> cpu_entry_area is used for more than just entry from userspace.  The gdt
> mapping, for instance, is needed everywhere.  You might want to go look
> at 'struct cpu_entry_area' in some more detail.
>
> > +#ifdef CONFIG_X86_ESPFIX64
> > +     rv = kvm_copy_mapping((void *)ESPFIX_BASE_ADDR, P4D_SIZE,
> > +          PGT_LEVEL_P4D);
> > +     if (rv)
> > +             goto out_uninit_page_table;
> > +#endif
>
> Why are these mappings *needed*?  I thought we only actually used these
> fixup stacks for some crazy iret-to-userspace handling.  We're certainly
> not doing that from KVM context.
>
> Am I forgetting something?
>
> > +#ifdef CONFIG_VMAP_STACK
> > +     /*
> > +      * Interrupt stacks are vmap'ed with guard pages, so we need to
> > +      * copy mappings.
> > +      */
> > +     for_each_possible_cpu(cpu) {
> > +             stack = per_cpu(hardirq_stack_ptr, cpu);
> > +             pr_debug("IRQ Stack %px\n", stack);
> > +             if (!stack)
> > +                     continue;
> > +             rv = kvm_copy_ptes(stack - IRQ_STACK_SIZE, IRQ_STACK_SIZE);
> > +             if (rv)
> > +                     goto out_uninit_page_table;
> > +     }
> > +
> > +#endif
>
> I seem to remember that the KVM VMENTRY/VMEXIT context is very special.
>  Interrupts (and even NMIs?) are disabled.  Would it be feasible to do
> the switching in there so that we never even *get* interrupts in the KVM
> context?

That would be nicer.

Looking at this code, it occurs to me that mapping the IRQ stacks
seems questionable.  As it stands, this series switches to a normal
CR3 in some C code somewhere moderately deep in the APIC IRQ code.  By
that time, I think you may have executed traceable code, and, if that
happens, you lose.  i hate to say this, but any shenanigans like this
patch does might need to happen in the entry code *before* even
switching to the IRQ stack.  Or perhaps shortly thereafter.

We've talked about moving context tracking to C.  If we go that route,
then this KVM context mess could go there, too -- we'd have a
low-level C wrapper for each entry that would deal with getting us
ready to run normal C code.

(We need to do something about terminology.  This kvm_mm thing isn't
an mm in the normal sense.  An mm has normal kernel mappings and
varying user mappings.  For example, the PTI "userspace" page tables
aren't an mm.  And we really don't want a situation where the vmalloc
fault code runs with the "kvm_mm" mm active -- it will totally
malfunction.)
