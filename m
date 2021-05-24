Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3545838E086
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 06:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhEXE7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 00:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhEXE7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 00:59:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3CEC061574
        for <kvm@vger.kernel.org>; Sun, 23 May 2021 21:57:48 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q67so2803056pfb.4
        for <kvm@vger.kernel.org>; Sun, 23 May 2021 21:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5elIPDTXRjLLPudcp8o02c7J6ZLjvAHG6TdyshBpqHM=;
        b=GWDeEevlJHCXyEL1BH5HMf5da6qvir0//wvvQybCoUH2K+Q2NqDqUCJp7MH7jOQI5g
         QKF/OOjUn+h+YmGjjHES0dGefuvap12Tr8lrjCxE8s9e2bId60fT490TEHBs1vtN0a+r
         ix9YhH1hTViU72dRKmc8cZl6nidX1fM/fhPBfsHWblsJywSPXlJUzOrdRS6tMMbvAVKK
         O2yLR1XwJth/8XHsuLJ+Rz2NUGlU1Q5IXK3Ttw3+cve/Uxqf7CqhvPJkSpNwfnn+KSbA
         c20a31xQuZGDFCMpLBACa4GOfpEz6kHEUw2PWJeJ/kmKJSPTXWADzF2OOQHpc+G0p1s1
         UOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5elIPDTXRjLLPudcp8o02c7J6ZLjvAHG6TdyshBpqHM=;
        b=e0RVPrinaQPStcgG6p0wCOEz2zJOiqylSmMLm4zZ09lAIfRnfxihmmPxsAVsJaFAuA
         poUqRYMIYnXu/x3KAzivwqt34DpcsWy5D5dBCSYC4prP2qkwgU3vt4o4dTpiz+CVc7Tu
         XdUKUtPO8oPZZt1ReiJn63jSwzZYjBR3kwP9cNndHK+WV/HBLbwqHjkSUS583P6MEVpC
         oMpZ0N5oOFkyRJoKiqvGjSlIOcW6hfBsGSYaE9N3C+AVIFmjA4KPZfHl5ydRJl8ssYU+
         y9O1j9+KTvOemZwLQ/strMbyd3M5b3bJCq8zq/IIaTSWUOawGx0F1p3Xaqv9ke+SKnCI
         1KhA==
X-Gm-Message-State: AOAM531xbSwQSS0t4MLnSYTTy/SuyG9gq8hYjsgcoADJDin2LbytwuVG
        f/BdNVPRyiC7Wm0Eha+hcq8vOfdldBvcMYRHGmvKSQ==
X-Google-Smtp-Source: ABdhPJz2s/6JAGw+NL3QrTHg+jeS1T5q4PDbtAvgk6IlTF0h9XB36MnFhjRoAg+6LOvjbpKDPjYCubpOO5MD1FRK2x0=
X-Received: by 2002:a63:1e4f:: with SMTP id p15mr11633324pgm.40.1621832267459;
 Sun, 23 May 2021 21:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-7-seanjc@google.com>
 <CAAeT=FzS0bP_7_wz6G6cL8-7pudTD7fhavLCVsOE0KnPXf99dQ@mail.gmail.com>
 <YKQiTlDG1sZ4Zd2E@google.com> <CAAeT=FzsXFNiteMB3sjskM401Ty4Ry_w80YcYB4ZYcZn0dqv5Q@mail.gmail.com>
 <YKVH4mzdAa+H9ROJ@google.com>
In-Reply-To: <YKVH4mzdAa+H9ROJ@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 23 May 2021 21:57:31 -0700
Message-ID: <CAAeT=Fz0Mn26riv3rG_x0ZXdrWLvqz=zv2g1064Os_jUdOhUaA@mail.gmail.com>
Subject: Re: [PATCH 06/43] KVM: x86: Properly reset MMU context at vCPU RESET/INIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 10:16 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, May 18, 2021, Reiji Watanabe wrote:
> > > > > +       if (kvm_cr0_mmu_role_changed(old_cr0, kvm_read_cr0(vcpu)) ||
> > > > > +           kvm_cr4_mmu_role_changed(old_cr4, kvm_read_cr4(vcpu)))
> > > > > +               kvm_mmu_reset_context(vcpu);
> > > > >  }
> > > >
> > > > I'm wondering if kvm_vcpu_reset() should call kvm_mmu_reset_context()
> > > > for a change in EFER.NX as well.
> > >
> > > Oooh.  So there _should_ be no need.   Paging has to be enabled for EFER.NX to
> > > be relevant, and INIT toggles CR0.PG 1=>0 if paging was enabled and so is
> > > guaranteed to trigger a context reset.  And we do want to skip the context reset,
> > > e.g. INIT-SIPI-SIPI when the vCPU has paging disabled should continue using the
> > > same MMU.
> > >
> > > But, kvm_calc_mmu_role_common() neglects to ignore NX if CR0.PG=0, and so the
> > > MMU role will be stale if INIT clears EFER.NX without forcing a context reset.
> > > However, that's benign from a functionality perspective because the context
> > > itself correctly incorporates CR0.PG, it's only the role that's borked.  I.e.
> > > KVM will fail to reuse a page/context due to the spurious role.nxe, but the
> > > permission checks are always be correct.
> > >
> > > I'll add a comment here and send a patch to fix the role calculation.
> >
> > Thank you so much for the explanation !
> > I understand your intention and why it would be benign.
> >
> > Then, I'm wondering if kvm_cr4_mmu_role_changed() needs to be
> > called here.  Looking at the Intel SDM, in my understanding,
> > all the bits kvm_cr4_mmu_role_changed() checks are relevant
> > only if paging is enabled.  (Or is my understanding incorrect ??)
>
> Duh, yes.  And it goes even beyond that, CR0.WP is only relevant if CR0.PG=1,
> i.e. INIT with CR0.PG=0 and CR0.WP=1 will incorrectly trigger a MMU reset with
> the current logic.
>
> Sadly, simply omitting the CR4 check puts us in an awkward situation where, due
> to the MMU role CR4 calculations not accounting for CR0.PG=0, KVM will run with
> a stale role.
>
> The other consideration is that kvm_post_set_cr4() and kvm_post_set_cr0() should
> also skip kvm_mmu_reset_context() if CR0.PG=0, but again that requires fixing
> the role calculations first (or at the same time).
>
> I think I'll throw in those cleanups to the beginning of this series.  The result
> is going to be disgustingly long, but I really don't want to introduce code that
> knowingly leaves KVM in an inconsistent state, nor do I want to add useless
> checks on CR4 and EFER.

Yes, I would think having the cleanups would be better.

Thank you !
Reiji
