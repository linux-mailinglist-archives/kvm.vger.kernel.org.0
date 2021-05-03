Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4346D37238E
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 01:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhECXYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 19:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhECXYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 19:24:06 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A48BC06174A
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 16:23:12 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id a9so4928285ilh.9
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 16:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sATyLz2AUjh/NEl61N+58SEsQ85RImR+kWn9Q6lYFwQ=;
        b=vProBvITgZKqrAHCml0iNoYIiE62Yp13NhB/JmOG04iqdKAyZA2xYLUWfpaj51UHV0
         WB88Be5RuzNvmMGjUMsQMU1sqGHXcrdsfnMPemghFFr+uJ6wznro8yedBnVtJ1oEg3QO
         wG9vjPgOljuLbfhCaTe/h63BbHHHTrjxe+fpSOWY84RrUeQVZnHCee4ffSwA+Gccj56o
         PBDd36Lglqn+rYHRiM7uHjdhf2tLr40hkDL1kE2JYfCh6EnrYkqGJ59fWJDk3iq+sqsy
         Vmn9W37qmvh0R2OEfAOHpVqtUMrFVF5ep5ICBJ26wJ5TYOnkB1huiHbGFwpOyE6c+1Xr
         oVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sATyLz2AUjh/NEl61N+58SEsQ85RImR+kWn9Q6lYFwQ=;
        b=iUI3jlcKCtBl7PGOkSIpN8ETxBztZUF6DOxbhcq53IALuAshxMCvAzA/bvFFbmOEqC
         9onLKeHiOPq5+dtpiDK9IlUwxisOFI5xQetLcMO1M8dqzXvTsygmv7x9MYw+yHHRgfOs
         2r36ppdBl2g8NPjaFpKB4J0H7fmRjZqZKkxgHwk6enhRxNiSd+zQPShp5RXbbAXSyGA1
         XacN3JkCrG4Eurdaz4+p7qFHV5iQ0P57nFnxyrvUfNGC5UkxXYsgU8VXPychhsg9n96Z
         /MaSQ5ns1jnZQiRUstwxVXhkobfFqvCbNMg0ieJX0eGP+zdmZKHnelpAc0ZwysH+YMKD
         oFsw==
X-Gm-Message-State: AOAM532WAWMaOYalj7bGi4WOYyaiuIXAL3rcgwk8/eR3gyOfKDAujLxP
        spqfqke3i3XU56yf886iBsfA1PJwgFH2/GKrXF3Icw==
X-Google-Smtp-Source: ABdhPJw7R3cTssC3VVNMo1hhlVY5+vIryOqVdAt+nXcn4qu/GnFlyWhV8b40ASXqnwlimiHNUSEQamxHExgxojk7ZJk=
X-Received: by 2002:a05:6e02:969:: with SMTP id q9mr7460898ilt.285.1620084191701;
 Mon, 03 May 2021 16:23:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210429104707.203055-1-pbonzini@redhat.com> <20210429104707.203055-3-pbonzini@redhat.com>
 <YIxkTZsblAzUzsf7@google.com> <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
In-Reply-To: <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 3 May 2021 16:22:35 -0700
Message-ID: <CABayD+f41GQwCL1818S7iogNHO+MLesLJ-hCX5Bbf_0vFfDMrw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 1, 2021 at 2:01 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/04/21 22:10, Sean Christopherson wrote:
> > On Thu, Apr 29, 2021, Paolo Bonzini wrote:
> >> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> >> index 57fc4090031a..cf1b0b2099b0 100644
> >> --- a/Documentation/virt/kvm/msr.rst
> >> +++ b/Documentation/virt/kvm/msr.rst
> >> @@ -383,5 +383,10 @@ MSR_KVM_MIGRATION_CONTROL:
> >>   data:
> >>           This MSR is available if KVM_FEATURE_MIGRATION_CONTROL is present in
> >>           CPUID.  Bit 0 represents whether live migration of the guest is allowed.
> >> +
> >>           When a guest is started, bit 0 will be 1 if the guest has encrypted
> >> -        memory and 0 if the guest does not have encrypted memory.
> >> +        memory and 0 if the guest does not have encrypted memory.  If the
> >> +        guest is communicating page encryption status to the host using the
> >> +        ``KVM_HC_PAGE_ENC_STATUS`` hypercall, it can set bit 0 in this MSR to
> >> +        allow live migration of the guest.  The MSR is read-only if
> >> +        ``KVM_FEATURE_HC_PAGE_STATUS`` is not advertised to the guest.
> >
> > I still don't get the desire to tie MSR_KVM_MIGRATION_CONTROL to PAGE_ENC_STATUS
> > in any way shape or form.  I can understand making it read-only or dropping
> > writes if it's not intercepted by userspace, but making it read-only for
> > non-encrypted guests makes it useful only for encrypted guests, which defeats
> > the purpose of genericizing the MSR.
>
> Yeah, I see your point.  On the other hand by making it unconditionally
> writable we must implement the writability in KVM, because a read-only
> implementation would not comply with the spec.
>
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index e9c40be9235c..0c2524bbaa84 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -3279,6 +3279,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>              if (!guest_pv_has(vcpu, KVM_FEATURE_MIGRATION_CONTROL))
> >>                      return 1;
> >>
> >> +            /*
> >> +             * This implementation is only good if userspace has *not*
> >> +             * enabled KVM_FEATURE_HC_PAGE_ENC_STATUS.  If userspace
> >> +             * enables KVM_FEATURE_HC_PAGE_ENC_STATUS it must set up an
> >> +             * MSR filter in order to accept writes that change bit 0.
> >> +             */
> >>              if (data != !static_call(kvm_x86_has_encrypted_memory)(vcpu->kvm))
> >>                      return 1;
> >
> > This behavior doesn't match the documentation.
> >
> >    a. The MSR is not read-only for legacy guests since they can write '0'.
> >    b. The MSR is not read-only if KVM_FEATURE_HC_PAGE_STATUS isn't advertised,
> >       a guest with encrypted memory can write '1' regardless of whether userspace
> >       has enabled KVM_FEATURE_HC_PAGE_STATUS.
>
> Right, I should have said "not changeable" rather than "read-only".
>
> >    c. The MSR is never fully writable, e.g. a guest with encrypted memory can set
> >       bit 0, but not clear it.  This doesn't seem intentional?
>
> It is intentional, clearing it would mean preserving the value in the
> kernel so that userspace can read it.
>
> So... I don't know, all in all having both the separate CPUID and the
> userspace implementation reeks of overengineering.  It should be either
> of these:
>
> - separate CPUID bit, MSR unconditionally writable and implemented in
> KVM.  Userspace is expected to ignore the MSR value for encrypted guests
> unless KVM_FEATURE_HC_PAGE_STATUS is exposed.  Userspace should respect
> it even for unencrypted guests (not a migration-DoS vector, because
> userspace can just not expose the feature).
>
> - make it completely independent from migration, i.e. it's just a facet
> of MSR_KVM_PAGE_ENC_STATUS saying whether the bitmap is up-to-date.  It
> would use CPUID bit as the encryption status bitmap and have no code at
> all in KVM (userspace needs to set up the filter and implement everything).
As far as I know, because of MSR filtering, the only "code" that needs
to be in KVM for MSR handling is a #define reserving the PV feature
number and a #define for the MSR number.

Arguably, you don't even need to add the new PV bits to the supported
cpuid, since MSR filtering is really what determines if kernel support
is present.

>
> At this point I very much prefer the latter, which is basically Ashish's
> earlier patch.
The minor distinction would be that if you expose the cpuid bit to the
guest you plan on intercepting the MSR with filters, and would not
need any handler code in the kernel.

Steve
>
> Paolo
