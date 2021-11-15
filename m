Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B42451599
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351245AbhKOUoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347399AbhKOTjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:39:49 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA698C06120C
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:30:08 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id k2so30299245lji.4
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JlBg5LtyqKvrpUdGEugnNnbVsAfgz6T1HCSvSGsjlZk=;
        b=GM4JCZ3y0BLNP/TxHX2RKDzwzQXrmBW3C2YVhDU0aTewQCnpDjP3k3KVYqcP9gtkkf
         a0vY7CrJ3Ao7m/3NH2aReiYRb0ktb4y8NsVCnG8VB9RLC1M/an8/s1yLEu+HLbf8rcFN
         iLQ+vuqBDlgbWLjd+SpjFNoacndfywNLpTnxuoMP9sz4B7oDAlkOkYvWzWi2XbmuE1z0
         l9Nd620wI7fij/Jfc1YZFf2aNuGYvBnJIAcQwBZk+ig/TCXePlNpJuUe7hheKF8RB9Ia
         X/Iwogst9O0aHNxoC716dOFOdcH49ifqcHR6Zx3s0khksOrtpHwaG7fHh1TqjX9/ZjYw
         Z5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JlBg5LtyqKvrpUdGEugnNnbVsAfgz6T1HCSvSGsjlZk=;
        b=sJSFvlblvn2biB/hO9EYrzyHc+uGvsW8Kyzm+NCcW876kSt8rYS3b1mBpzZdSH0hxE
         3tcpadstOrNMxrur53vzvJAtPb1t8jD8T1tn1CHitzlG1O+QJJrt1mj/XpWds92SjlG2
         WCe7G/eHhSLQ46jJNTFD0dJ4MPbKAzUrVhSvxpfVNo2EDK/w6br4f5R5d9E7TKJfMSsh
         e1CIG1mTWLDI+wTpH5XxWNvV7kQzRA36NzLr4sQ6hZrJJ3Cy1ApJzOc4VSgGNm8Gl8T7
         qCMISQqCVBfJgSSSeSQruhmx6zwdBXuED4jkwviYrwbr5FjF4+lg/iNnk3nK7enYluuF
         cpkQ==
X-Gm-Message-State: AOAM530tJiR+JhH6Vo4j1GC3z9JKsDC6Vfs086uN4AkCH6wJ1NMk7uhT
        ea+hWSkmLxlSASRcW+wl7Uhq1fuUvHwDn/1tij3+2A==
X-Google-Smtp-Source: ABdhPJzE8zq/IQ4W4/8Y/EEjilAn9vCsEXb84iRBWktB/ycTLjv28nMT0r/8iAKgJiA4OXYHBe6L2zu42b2iPQv+NNU=
X-Received: by 2002:a2e:8895:: with SMTP id k21mr1005211lji.331.1637004607113;
 Mon, 15 Nov 2021 11:30:07 -0800 (PST)
MIME-Version: 1.0
References: <20211111221448.2683827-1-seanjc@google.com> <CALzav=dpzzKgaNRLrSBy71WBvybWmRJ39eDv4hPXsbU_DSS-fA@mail.gmail.com>
 <YZKzr4mn1jJ3vdqK@google.com>
In-Reply-To: <YZKzr4mn1jJ3vdqK@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 15 Nov 2021 11:29:40 -0800
Message-ID: <CALzav=fKycSowAyaymt9a9hpffbWnFeXvACC5pE5-rMpx+4H4g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Update number of zapped pages even if page
 list is stable
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 11:23 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 15, 2021, David Matlack wrote:
> > On Thu, Nov 11, 2021 at 2:14 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > When zapping obsolete pages, update the running count of zapped pages
> > > regardless of whether or not the list has become unstable due to zapping
> > > a shadow page with its own child shadow pages.  If the VM is backed by
> > > mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
> > > the batch count and thus without yielding.  In the worst case scenario,
> > > this can cause an RCU stall.
> > >
> > >   rcu: INFO: rcu_sched self-detected stall on CPU
> > >   rcu:     52-....: (20999 ticks this GP) idle=7be/1/0x4000000000000000
> > >                                           softirq=15759/15759 fqs=5058
> > >    (t=21016 jiffies g=66453 q=238577)
> > >   NMI backtrace for cpu 52
> > >   Call Trace:
> > >    ...
> > >    mark_page_accessed+0x266/0x2f0
> > >    kvm_set_pfn_accessed+0x31/0x40
> > >    handle_removed_tdp_mmu_page+0x259/0x2e0
> > >    __handle_changed_spte+0x223/0x2c0
> > >    handle_removed_tdp_mmu_page+0x1c1/0x2e0
> > >    __handle_changed_spte+0x223/0x2c0
> > >    handle_removed_tdp_mmu_page+0x1c1/0x2e0
> > >    __handle_changed_spte+0x223/0x2c0
> > >    zap_gfn_range+0x141/0x3b0
> > >    kvm_tdp_mmu_zap_invalidated_roots+0xc8/0x130
> >
> > This is a useful patch but I don't see the connection with this stall.
> > The stall is detected in kvm_tdp_mmu_zap_invalidated_roots, which runs
> > after kvm_zap_obsolete_pages. How would rescheduling during
> > kvm_zap_obsolete_pages help?
>
> Ah shoot, I copy+pasted the wrong splat.  The correct, revelant backtrace is:

Ok that makes more sense :). Also that was a soft lockup rather than
an RCU stall.
>
>    mark_page_accessed+0x266/0x2e0
>    kvm_set_pfn_accessed+0x31/0x40
>    mmu_spte_clear_track_bits+0x136/0x1c0
>    drop_spte+0x1a/0xc0
>    mmu_page_zap_pte+0xef/0x120
>    __kvm_mmu_prepare_zap_page+0x205/0x5e0
>    kvm_mmu_zap_all_fast+0xd7/0x190
>    kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
>    kvm_page_track_flush_slot+0x5c/0x80
>    kvm_arch_flush_shadow_memslot+0xe/0x10
>    kvm_set_memslot+0x1a8/0x5d0
>    __kvm_set_memory_region+0x337/0x590
>    kvm_vm_ioctl+0xb08/0x1040
