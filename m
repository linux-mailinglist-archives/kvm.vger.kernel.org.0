Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C34402E1E
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345559AbhIGSGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345038AbhIGSGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 14:06:46 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9236CC061757
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 11:05:39 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id x10so2491702ilm.12
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qzpzgK3vW8zHPmHABhnfN3E8pmOfA9CLtZXPUD7O1yA=;
        b=VFDD3+qB1T70aPLYjMFO8iu9L5Ye5pHkxGgSF+BsKCbgrI/ivvRtvOUDnYL22P2B6F
         Geitq9A0wVPm7nSIFKaYJm/jeB3BQ/vCv3QOVkgPIMZ5Go4x7Vju/n+BnPfMR6FfVA3q
         vWZ041iqLVDxMATcQ4Qb+XIlGKVd7jXGsbJ3ZeEYQ0BQD/SLoEXLaLNDLcLjCFkTsGaW
         fi7AeZCFw8ayEIch3nQO/S6OkhDQywgrd9yMPgL1m2MR8zQMhGqTl6tUM6907assvL9z
         +KidFvJ0FG5Hm6gtPX+rShAuHUEVgqUDLBdAnKGA1fD7ZrMuc5nG79vVHfuiVE2mlPEH
         6D6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qzpzgK3vW8zHPmHABhnfN3E8pmOfA9CLtZXPUD7O1yA=;
        b=kjKOlaCdD7s3AK7IZQA6rxbpN860nRRF0eTcrZzBuNoE0E3UlDw4sIPWnRQckf7bK+
         7AUILtj2MegWNwRDQ892lHlIJZbg4EfY+4vJxBxqGT3RWJ8A7oT7eSso7rf/uDIZJzS6
         JPOO1/QrDdAQ62UXbzVb799ASjKoYzAQJFo9rdm2zEkYyODzzp4N88loJgv0TCmqPfYX
         GW0a/M1Fb7yEXEroq8uC9mwPq4joiaMLzIy2GqSDmhCZl+Gzc2pJzEAQtnDxRDBO0WHG
         eIXz2RWkew7vr6Ql2bjNNU84gIHZuZM7z1yUOoriAPN79BjqBYkh64DP2NU3y7GAfM+a
         c/Vg==
X-Gm-Message-State: AOAM532dYnN/yqDy6yi3yjMWkFzRFUsApB/Fj36SR7l+UMCzzsqY4yCl
        kuCTwE8gnqLz/XHuvapyPAvzxfoP4ZbPjAgV0+ShCA==
X-Google-Smtp-Source: ABdhPJwGjNRsARjK37GX3NrPfYazkOzZO+CMfXuxbNbqXapBb+yZmKH7Ce0+n6QGLp+mht0dQVWIvz2nCCOxYLT99a8=
X-Received: by 2002:a92:c5aa:: with SMTP id r10mr12869774ilt.274.1631037938808;
 Tue, 07 Sep 2021 11:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006096fa05cb454a9c@google.com> <YTehmR1+G34uOHh3@google.com>
In-Reply-To: <YTehmR1+G34uOHh3@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 7 Sep 2021 11:05:27 -0700
Message-ID: <CANgfPd_yUH6cuVQ54oKRkU3NQ6oevE8ySeeyW=AvAnj4S_AT+w@mail.gmail.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in memslot_rmap_alloc
To:     Sean Christopherson <seanjc@google.com>
Cc:     syzbot <syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>, dave.hansen@linux.intel.com,
        "H. Peter Anvin" <hpa@zytor.com>, jarkko@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 7, 2021 at 10:30 AM Sean Christopherson <seanjc@google.com> wrote:
>
> +Linus and Ben
>
> On Sun, Sep 05, 2021, syzbot wrote:
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 8419 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> > Modules linked in:
> > CPU: 0 PID: 8419 Comm: syz-executor520 Not tainted 5.14.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
>
> ...
>
> > Call Trace:
> >  kvmalloc include/linux/mm.h:806 [inline]
> >  kvmalloc_array include/linux/mm.h:824 [inline]
> >  kvcalloc include/linux/mm.h:829 [inline]
> >  memslot_rmap_alloc+0xf6/0x310 arch/x86/kvm/x86.c:11320
> >  kvm_alloc_memslot_metadata arch/x86/kvm/x86.c:11388 [inline]
> >  kvm_arch_prepare_memory_region+0x48d/0x610 arch/x86/kvm/x86.c:11462
> >  kvm_set_memslot+0xfe/0x1700 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1505
> >  __kvm_set_memory_region+0x761/0x10e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1668
> >  kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1689 [inline]
> >  kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1701 [inline]
> >  kvm_vm_ioctl+0x4c6/0x2330 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4236
>
> KVM is tripping the WARN_ON_ONCE(size > INT_MAX) added in commit 7661809d493b
> ("mm: don't allow oversized kvmalloc() calls").  The allocation size is absurd and
> doomed to fail in this particular configuration (syzkaller is just throwing garbage
> at KVM), but for humongous virtual machines it's feasible that KVM could run afoul
> of the sanity check for an otherwise legitimate allocation.
>
> The allocation in question is for KVM's "rmap" to translate a guest pfn to a host
> virtual address.  The size of the rmap in question is an unsigned long per 4kb page
> in a memslot, i.e. on x86-64, 8 bytes per 4096 bytes of guest memory in a memslot.
> With INT_MAX=0x7fffffff, KVM will trip the WARN and fail rmap allocations for
> memslots >= 1tb, and Google already has VMs that create 1.5tb memslots (12tb of
> total guest memory spread across 8 virtual NUMA nodes).
>
> One caveat is that KVM's newfangled "TDP MMU" was designed specifically to avoid
> the rmap allocation (among other things), precisely because of its scalability
> issues.  I.e. it's unlikely KVM's so called "legacy MMU" that relies on the rmaps
> would be used for such large VMs.  However, KVM's legacy MMU is still the only option
> for shadowing nested EPT/NPT, i.e. the rmap allocation would be problematic if/when
> nested virtualization is enabled in large VMs.
>
> KVM also has other allocations based on memslot size that are _not_ avoided by KVM's
> TDP MMU and may eventually be problematic, though presumably not for quite some time
> as it would require petabyte? memslots.  E.g. a different metadata array requires
> 4 bytes per 2mb of guest memory.

KVM's dirty bitmap requires 1 bit per 4K, so we'd hit this limit even
sooner with 64TB memslots.
Still, that can be avoided with Peter Xu's dirty ring and we're still
a ways away from 64TB memslots.

>
> I don't have any clever ideas to handle this from the KVM side, at least not in the
> short term.  Long term, I think it would be doable to reduce the rmap size for large
> memslots by 512x, but any change of that nature would be very invasive to KVM and
> be fairly risky.  It also wouldn't prevent syskaller from triggering this WARN at will.

Not the most elegant solution, but KVM could, and perhaps should,
impose a maximum memslot size. KVM operations (e.g. dirty logging)
which operate on a memslot can take a very long time with terabyte
memslots. Forcing userspace to handle memory in units of a more
reasonable size could be a good limitation to impose sooner rather
than later while there are few users (if any outside Google) of these
massive memslots.
