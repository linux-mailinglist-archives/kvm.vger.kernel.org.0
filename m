Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6362345982E
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 00:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhKVXHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 18:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhKVXHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 18:07:09 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03791C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 15:04:02 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id w4so8619553ilv.12
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 15:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tz3Lamka2YWw1ugKbuX9+hCMQFBh2lnWq929aaGVVgE=;
        b=ph7uvnZiFUq/ff+ocagZiD+GeIG5MPPSlug2Ty+mOZzKrnXwc8a7i16KSuG+B/5AM1
         11p1IvTfszKs/ptL2Xjd36jNO1ZgtaTSkMpSzHZ45XNMwMn2+9h0gNEDaVNbiyY0C2/g
         2M/QSW6aI1qjEr2+XWMJspjgxvs5ttE6zqtXImgMiNyR3qgUOCn5JVS33Kv61zp9wgBh
         a3DtSfGfLjg6zSfllVmtQUkKl/J1w9M/dwGb8OrwBIyW9sKFAF6CyRfd2Rfg7RJHpgwl
         qvirWf9Dg9sxlKToRuZ5RdIoRXbGKKmtbj1Q7LyXJpIfwauADWaUZ88TDUHLGDB6mwoU
         dt5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tz3Lamka2YWw1ugKbuX9+hCMQFBh2lnWq929aaGVVgE=;
        b=ynLUOm0yo7M8kBj1GhrtM4oV3QsvHRPPuFgh3VKD1Z6QVAWpTNRjcilr45uL4wNQpc
         BIDrs8dqeqmJsRII5CJOEa1hnu9mEBryZlQ/NXQG6ynjOPkvfl+i1S6cktqRUHti5OfT
         v5fGAQnTr8BS2UzaaNhSfAEtzLtDc1Aa0JDJF3YUiLoke1MuOsKNyqdATDjS75iQKsXh
         745CE00fUltm60P5zOCmIKV42Zaclb7ZbVadNVJMOJBaHyFVaLMpiSt/rnboKfwbjOFN
         8S5VFOqfaH6NCn7oWgNM2odN8QpQqsYAB1aprD0fpIjXyKribnl5m16VQzZWV2DNn9IP
         fF3Q==
X-Gm-Message-State: AOAM533QwLx48l7bQES8jXzGq8oM8Ct4L3NcXt4anaqNu+cNQA8GKbVi
        Y90Ccr+c1Y/8IJggCF9xTSL7KJ4RSNtSwbQ8MjYJpA==
X-Google-Smtp-Source: ABdhPJyd6leyGJJwvBDnFoD8APFPNMT8rOixMoghmRYjLvjtKT3G1a4IcVfJY8HWBWHnVwqCIDpSV9MSkcHdBGqFwNU=
X-Received: by 2002:a92:cda2:: with SMTP id g2mr662459ild.2.1637622241357;
 Mon, 22 Nov 2021 15:04:01 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-11-seanjc@google.com>
 <CANgfPd_H3CZn_rFfEZoZ7Sa==Lnwt4tXSMsO+eg5d8q9n39BSQ@mail.gmail.com> <YZwcbu/qt3obyWSK@google.com>
In-Reply-To: <YZwcbu/qt3obyWSK@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 15:03:50 -0800
Message-ID: <CANgfPd-Kb9PwB=3nHFwGE4M2cg40h7QpbEU1ZedfKVwGtgCyVA@mail.gmail.com>
Subject: Re: [PATCH 10/28] KVM: x86/mmu: Allow yielding when zapping GFNs for
 defunct TDP MMU root
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 2:40 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 22, 2021, Ben Gardon wrote:
> > On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Allow yielding when zapping SPTEs for a defunct TDP MMU root.  Yielding
> > > is safe from a TDP perspective, as the root is unreachable.  The only
> > > potential danger is putting a root from a non-preemptible context, and
> > > KVM currently does not do so.
> > >
> > > Yield-unfriendly iteration uses for_each_tdp_mmu_root(), which doesn't
> > > take a reference to each root (it requires mmu_lock be held for the
> > > entire duration of the walk).
> > >
> > > tdp_mmu_next_root() is used only by the yield-friendly iterator.
> > >
> > > kvm_tdp_mmu_zap_invalidated_roots() is explicitly yield friendly.
> > >
> > > kvm_mmu_free_roots() => mmu_free_root_page() is a much bigger fan-out,
> > > but is still yield-friendly in all call sites, as all callers can be
> > > traced back to some combination of vcpu_run(), kvm_destroy_vm(), and/or
> > > kvm_create_vm().
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> >
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> >
> > I'm glad to see this fixed. I assume we don't usually hit this in
> > testing because most of the teardown happens in the zap-all path when
> > we unregister for MMU notifiers
>
> Or more likely, when the userspace process exits and kvm_mmu_notifier_ops.release
> is invoked.  But yeah, same difference, VM teardown is unlikely to trigger zapping
> by putting the last TDP MMU reference.
>
> > and actually deleting a fully populated root while the VM is running is pretty
> > rare.
>
> Hmm, probably not that rare, e.g. guest reboot (emulated RESET) is all but
> guaranteed to trigger kvm_mmu_reset_context() on all vCPUs and thus drop all roots,
> and QEMU at least doesn't (always) do memslot updates as part of reboot.

I don't think we have a selftest or kvm-unit-test that builds a large
EPT structure and then reboots the guest though. That'd be a cool test
to have.
