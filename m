Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B53D7D48
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhG0SRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhG0SRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:17:38 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEF1C061757
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:17:37 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e14so16788167plh.8
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+s15nut/2SxrGQ322z8+gWVFmP+vDGNZBfdbvFgLxUE=;
        b=Itw6lhNN5TGYy0Peur2pD3tsj4JAjzMGqY1gicu3nnEiQigCTChrZwCUEoe3sNQr0f
         M1aym5fGw5OL4WEUnWMiYnQ0tHR+YjyiwuM7iCtbm0/FWYtlmIC5EbncykR0nQ5KbEHZ
         MGPfxxSH7sxTTAOJfKUJHTP33N46xStQmPCjKu08VetOHx+Ry/CDTD1M+hUskSWieV7r
         4SVbAbf6oQV3eS9qGiwAikzN//gkbd+2il7Oa0y0yKKF7YtQweFyQw/s/1ey2cejdWUG
         G00EqJ97Ai7+bzGNtBgp6hp8fIY97Hs4c0Vdakp+ZH9ECCpSQXSM1CT1zS/RvphLrKMh
         9Cvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+s15nut/2SxrGQ322z8+gWVFmP+vDGNZBfdbvFgLxUE=;
        b=kMQUgnsrdymgK0z9a70GSe1V6M4f7AaSJTfeaBCM/2QlqG7nndjeX5o+tf/xyDYvat
         qtlyKQ6mr1XrT8sQXiePJc+wkSR0+PvoRnY+6dFudcfg1FFyLlJ14vUijFmJjpA/ffdl
         PEU8GTblei3EhMowH/V+TTaZhrEP1nfiZ5Jfy5wSIMoHV/hLfZ2aGYosIIS1A5Hn4dyk
         wGpGgNL89bggt0IQ4XZ7KPrynbWfpBsOSokbPoCabgRKSa+qrlFyibBRXakm54At/6Ev
         9rk4dzguz01voUQ5y1SYeTYwmUXazDz9qwwOIfml8w95tSXJh3u738M2LxzugEIGcZ8k
         GFbg==
X-Gm-Message-State: AOAM532Ny0EKR5IENX4e7voBO3eVNvD1ONbSJ4SimSjm8U0zPZGtG3oG
        9FlEyLNl67Q8EIp4sw5hH12Z1g==
X-Google-Smtp-Source: ABdhPJxnM+yVhevOr4ODOgBtLtNa4xe1T8NrWQtiNLb6khNrYl+l1cYuSHLE+Y3yLf20WBkkOWHmVA==
X-Received: by 2002:a17:90a:19c2:: with SMTP id 2mr23625400pjj.233.1627409857193;
        Tue, 27 Jul 2021 11:17:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k198sm4509280pfd.148.2021.07.27.11.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:17:36 -0700 (PDT)
Date:   Tue, 27 Jul 2021 18:17:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v2 8/8] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
Message-ID: <YQBNvLg8WZiKVLBx@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
 <20210713142023.106183-9-mlevitsk@redhat.com>
 <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
 <YPXJQxLaJuoF6aXl@google.com>
 <64ed28249c1895a59c9f2e2aa2e4c09a381f69e5.camel@redhat.com>
 <YPnBxHwMJkTSBHfC@google.com>
 <714b56eb83e94aca19e35a8c258e6f28edc0a60d.camel@redhat.com>
 <CANgfPd_o5==utejx6iG9xfWrbKtsvGWNbB4yrmuA-NVj_r_a9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_o5==utejx6iG9xfWrbKtsvGWNbB4yrmuA-NVj_r_a9A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021, Ben Gardon wrote:
> On Tue, Jul 27, 2021 at 6:06 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> >
> > On Thu, 2021-07-22 at 19:06 +0000, Sean Christopherson wrote:
> > > The elevated mmu_notifier_count and/or changed mmu_notifier_seq will cause vCPU1
> > > to bail and resume the guest without fixing the #NPF.  After acquiring mmu_lock,
> > > vCPU1 will see the elevated mmu_notifier_count (if kvm_zap_gfn_range() is about
> > > to be called, or just finised) and/or a modified mmu_notifier_seq (after the
> > > count was decremented).
> > >
> > > This is why kvm_zap_gfn_range() needs to take mmu_lock for write.  If it's allowed
> > > to run in parallel with the page fault handler, there's no guarantee that the
> > > correct apic_access_memslot_enabled will be observed.
> >
> > I understand now.
> >
> > So, Paolo, Ben Gardon, what do you think. Do you think this approach is feasable?
> > Do you agree to revert the usage of the read lock?
> >
> > I will post a new series using this approach very soon, since I already have
> > msot of the code done.
> >
> > Best regards,
> >         Maxim Levitsky
> 
> From reading through this thread, it seems like switching from read
> lock to write lock is only necessary for a small range of GFNs, (i.e.
> the APIC access page) is that correct?

For the APICv case, yes, literally a single GFN (the default APIC base).

> My initial reaction was that switching kvm_zap_gfn_range back to the
> write lock would be terrible for performance, but given its only two
> callers, I think it would actually be fine.

And more importantly, the two callers are gated by kvm_arch_has_noncoherent_dma()
and are very rare flows for the guest (updating MTRRs, toggling CR0.CD).

> If you do that though, you should pass shared=false to
> kvm_tdp_mmu_zap_gfn_range in that function, so that it knows it's
> operating with exclusive access to the MMU lock.

Ya, my suggested revert was to drop @shared entirely since kvm_zap_gfn_range() is
the only caller that passes @shared=true.
