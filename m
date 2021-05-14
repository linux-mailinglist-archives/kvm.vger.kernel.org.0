Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F586380BA8
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhENOUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 10:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhENOUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 10:20:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115B3C061574
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 07:19:36 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j10so43285942lfb.12
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 07:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tOxw5SVmfBmJZsWVp0ash7xR3bvJRYuIJQ5qFXcsXHA=;
        b=tx9wU1U5hFECpxyCJDRlhGXtDfy5TaCOxVKsp1w1DqOQrSOY9xmc/ylcDPqpLM0aS0
         D17DXI4qMe5zZAKrEaWDux6YMIKH0ys38LI16Kli1zM3w7J/ibXVNT6RorpUowGenRJf
         C3gYZRib/2QIEV+/KsW84xaFkms5I5tHsP33XzqOHl1nxIw05ZftRBnirHyF5rzOSCOq
         dNbirna9PEEc9L3Fwfe3+yEIn/JwvjxJaSH1WiyQfuhjf6PdPu7bNtmWqUSHOx3/Gwap
         ia1AM+e2wYQvU8+Fp1Yz5WnJTr5MbNMTlhsjwh8vOIXRGSbAalsZgWldVGpoyoYFspsU
         zLiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tOxw5SVmfBmJZsWVp0ash7xR3bvJRYuIJQ5qFXcsXHA=;
        b=CeCJzhvMVLNWfsizYPtRUQPzwCe16MIkwIpFRQFVuTtRFQifWXJCbu5r/O/M1ghzH/
         /XpWKlqAkGXAK+skC5HswHMvSODB/RDyteiO1pkJw0qJyaUfwKUkW+cW2Fqrht8FyKKP
         qhAmkEhGIaZwXpS0SstYPR4PhHA1iri1gPdDrgOQt+Gs179NMY4YAH8FRPTLid0hE48b
         p48jECis3+yi0oTTQrxLdWTf+/UWoVzgk9EvKoZj2UIIwloaFPj+9ZzRzdQedTy6foKl
         MEjk53fc/B1+JHJ82O3nc6bWBPSHPLf9AQQsCDhVZ47j4Xj2SP9yQEWAtCtw1KRcV1gy
         b5JA==
X-Gm-Message-State: AOAM533RxdRYh7YRcRGR2ECRS38YFvwEg371Bb/dMKgf+laGe2o8XRDX
        Yf2gOPbV9qUa0jMFoixUIVPlhE4we2JlYDnQNz12XolWHmuGeg==
X-Google-Smtp-Source: ABdhPJyztTPoI5ip03CK9uHqiAzOpWhGS6wgDBjUCoBF7m3cu+w6U9xkx5o1iA9rNnGMBDcaP0jiec0vXByQSv+2vGo=
X-Received: by 2002:a19:431b:: with SMTP id q27mr31293840lfa.226.1621001974221;
 Fri, 14 May 2021 07:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210507165947.2502412-1-seanjc@google.com> <20210507165947.2502412-3-seanjc@google.com>
 <5f084672-5c0d-a6f3-6dcf-38dd76e0bde0@amd.com> <YJla8vpwqCxqgS8C@google.com>
In-Reply-To: <YJla8vpwqCxqgS8C@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 14 May 2021 08:19:22 -0600
Message-ID: <CAMkAt6oL9tfF5rvP0htbQNDPr50Zk41Q4KP-dM0N+SJ7xmsWvw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Allow userspace to update tracked sregs for
 protected guests
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 10:10 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, May 07, 2021, Tom Lendacky wrote:
> > On 5/7/21 11:59 AM, Sean Christopherson wrote:
> > > Allow userspace to set CR0, CR4, CR8, and EFER via KVM_SET_SREGS for
> > > protected guests, e.g. for SEV-ES guests with an encrypted VMSA.  KVM
> > > tracks the aforementioned registers by trapping guest writes, and also
> > > exposes the values to userspace via KVM_GET_SREGS.  Skipping the regs
> > > in KVM_SET_SREGS prevents userspace from updating KVM's CPU model to
> > > match the known hardware state.
> >
> > This is very similar to the original patch I had proposed that you were
> > against :)
>
> I hope/think my position was that it should be unnecessary for KVM to need to
> know the guest's CR0/4/0 and EFER values, i.e. even the trapping is unnecessary.
> I was going to say I had a change of heart, as EFER.LMA in particular could
> still be required to identify 64-bit mode, but that's wrong; EFER.LMA only gets
> us long mode, the full is_64_bit_mode() needs access to cs.L, which AFAICT isn't
> provided by #VMGEXIT or trapping.
>
> Unless I'm missing something, that means that VMGEXIT(VMMCALL) is broken since
> KVM will incorrectly crush (or preserve) bits 63:32 of GPRs.  I'm guessing no
> one has reported a bug because either (a) no one has tested a hypercall that
> requires bits 63:32 in a GPR or (b) the guest just happens to be in 64-bit mode
> when KVM_SEV_LAUNCH_UPDATE_VMSA is invoked and so the segment registers are
> frozen to make it appear as if the guest is perpetually in 64-bit mode.
>
> I see that sev_es_validate_vmgexit() checks ghcb_cpl_is_valid(), but isn't that
> either pointless or indicative of a much, much bigger problem?  If VMGEXIT is
> restricted to CPL0, then the check is pointless.  If VMGEXIT isn't restricted to
> CPL0, then KVM has a big gaping hole that allows a malicious/broken guest
> userspace to crash the VM simply by executing VMGEXIT.  Since valid_bitmap is
> cleared during VMGEXIT handling, I don't think guest userspace can attack/corrupt
> the guest kernel by doing a replay attack, but it does all but guarantee a
> VMGEXIT at CPL>0 will be fatal since the required valid bits won't be set.
>
> Sadly, the APM doesn't describe the VMGEXIT behavior, nor does any of the SEV-ES
> documentation I have.  I assume VMGEXIT is recognized at CPL>0 since it morphs
> to VMMCALL when SEV-ES isn't active.
>
> I.e. either the ghcb_cpl_is_valid() check should be nuked, or more likely KVM
> should do something like this (and then the guest needs to be updated to set the
> CPL on every VMGEXIT):
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a9d8d6aafdb8..bb7251e4a3e2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2058,7 +2058,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>         vcpu->arch.regs[VCPU_REGS_RDX] = ghcb_get_rdx_if_valid(ghcb);
>         vcpu->arch.regs[VCPU_REGS_RSI] = ghcb_get_rsi_if_valid(ghcb);
>
> -       svm->vmcb->save.cpl = ghcb_get_cpl_if_valid(ghcb);
> +       svm->vmcb->save.cpl = 0;
>
>         if (ghcb_xcr0_is_valid(ghcb)) {
>                 vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> @@ -2088,6 +2088,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>         if (ghcb->ghcb_usage)
>                 goto vmgexit_err;
>
> +       /* Ignore VMGEXIT at CPL>0 */
> +       if (!ghcb_cpl_is_valid(ghcb) || ghcb_get_cpl_if_valid(ghcb))
> +               return 1;
> +
>         /*
>          * Retrieve the exit code now even though is may not be marked valid
>          * as it could help with debugging.
> @@ -2142,8 +2146,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>                 }
>                 break;
>         case SVM_EXIT_VMMCALL:
> -               if (!ghcb_rax_is_valid(ghcb) ||
> -                   !ghcb_cpl_is_valid(ghcb))
> +               if (!ghcb_rax_is_valid(ghcb))
>                         goto vmgexit_err;
>                 break;
>         case SVM_EXIT_RDTSCP:
>
> > I'm assuming it's meant to make live migration a bit easier?
>
> Peter, I forget, were these changes necessary for your work, or was the sole root
> cause the emulated MMIO bug in our backport?
>
> If KVM chugs along happily without these patches, I'd love to pivot and yank out
> all of the CR0/4/8 and EFER trapping/tracking, and then make KVM_GET_SREGS a nop
> as well.

Let me look at if these changes are necessary for our SEV-ES copyless
migration. My initial thoughts are that we still need CR8 trapping and
setting/getting since its not stored in the VMSA. But I don't think
we'll need the others.
