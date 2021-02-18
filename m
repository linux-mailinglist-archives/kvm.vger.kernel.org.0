Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9548231EE66
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhBRSef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbhBRRzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 12:55:52 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E68C061756
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:55:12 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id q4so2644470otm.9
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tgi2PT/4+anU3pfYa8JYNys7ChKyAjV7/eCb1ADvlbQ=;
        b=qnE6/yHiDn67OdK7pvvUIINFuUG0S7jPrr6b+2c9mMjTNonTCnBWnGpIwWe1t3UQcG
         CpBm51EqMP4Wns59KX4czCyugG21sPLFkFMHuYE7SkXkX8NfYQmKW013EmuPJWXwqy+3
         +hEyGZm/ZL+7DK+fNy9PTWj4OFleCawPLaOK+fXIwwDiIvDVbFXMx3L76C04CpnDdhZd
         yRh+2OFj6Xs7Foamx9ojJ+rktQ6XVgtH4xk/JQohBbaI0u7VUlxmVTKHTV1OVfS4u8ZF
         ChRahBKg3/KFerxqZZq+cRsFzwZjPWHc07YQ4mKX0cgPTOVOdbdhztLFuBVv1Z16Bfbx
         IpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tgi2PT/4+anU3pfYa8JYNys7ChKyAjV7/eCb1ADvlbQ=;
        b=ttuOY/ApGYTUhe2/jSPZH8nNm9KXttKoYZhoyw7NOr+VePEX234fWt+NwDgFJE0kg3
         Wmzll0ZnVPgyrrOet0afT+AZCU8k1MW2MlO2f3dH3flEi1t57N30EVmW8cPn+BMmXjmu
         2mcsc9Wk+4qVoVctfjnyJ7H1p7PDIvImGN3kRFb5sjhd+OKd+pNg5BwwW+mHHqtN+tUh
         8Q559p5dFV3O7VT2j0MMz7DCGofqYmdnrTyG4URsRmknUhVPajPqwQ9YmOmQ7YeirsAc
         Lnk12fGMarmUSIG1yoMxLPgK6DGH+Mwd9ejtOw/6EP9todzZilPWc+rM2/pq7eGtNdt7
         XBww==
X-Gm-Message-State: AOAM532jrV8LVeF9IiA8WMGOSCCADZOjw2O4MR95zALGU1ijaKiNPPFv
        7CKiSjy3beLDdjwKrCUx9LtN7notEj8+sDr2jERgGg==
X-Google-Smtp-Source: ABdhPJxFq2xp4sEJi4/hmbQAsrJdWcJiX+FB/+//cEcqbBtjBEZwTThD0tidD8SXZHFNNbODkrlqFAox11M6bmbDA3Q=
X-Received: by 2002:a9d:7a47:: with SMTP id z7mr3786711otm.295.1613670911413;
 Thu, 18 Feb 2021 09:55:11 -0800 (PST)
MIME-Version: 1.0
References: <20210218100450.2157308-1-david.edmondson@oracle.com>
 <708f2956-fa0f-b008-d3d2-93067f95783c@redhat.com> <cuntuq9ilg4.fsf@dme.org>
 <8f9d4ef7-ddad-160b-2d94-69f4370e8702@redhat.com> <YC6XVrWPRQJ7V6Nd@google.com>
In-Reply-To: <YC6XVrWPRQJ7V6Nd@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 18 Feb 2021 09:55:00 -0800
Message-ID: <CALMp9eTX4Na2VTY2aU=-SUrGhst5aExdCB3f=4krKj1mFPgcqQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, David Edmondson <dme@dme.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021 at 8:35 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Feb 18, 2021, Paolo Bonzini wrote:
> > On 18/02/21 13:56, David Edmondson wrote:
> > > On Thursday, 2021-02-18 at 12:54:52 +01, Paolo Bonzini wrote:
> > >
> > > > On 18/02/21 11:04, David Edmondson wrote:
> > > > > When dumping the VMCS, retrieve the current guest value of EFER from
> > > > > the kvm_vcpu structure if neither VM_EXIT_SAVE_IA32_EFER or
> > > > > VM_ENTRY_LOAD_IA32_EFER is set, which can occur if the processor does
> > > > > not support the relevant VM-exit/entry controls.
> > > >
> > > > Printing vcpu->arch.efer is not the best choice however.  Could we dump
> > > > the whole MSR load/store area instead?
> > >
> > > I'm happy to do that, and think that it would be useful, but it won't
> > > help with the original problem (which I should have explained more).
> > >
> > > If the guest has EFER_LMA set but we aren't using the entry/exit
> > > controls, vm_read64(GUEST_IA32_EFER) returns 0, causing dump_vmcs() to
> > > erroneously dump the PDPTRs.
> >
> > Got it now.  It would sort of help, because while dumping the MSR load/store
> > area you could get hold of the real EFER, and use it to decide whether to
> > dump the PDPTRs.
>
> EFER isn't guaranteed to be in the load list, either, e.g. if guest and host
> have the same desired value.
>
> The proper way to retrieve the effective EFER is to reuse the logic in
> nested_vmx_calc_efer(), i.e. look at VM_ENTRY_IA32E_MODE if EFER isn't being
> loaded via VMCS.

Shouldn't dump_vmcs() simply dump the contents of the VMCS, in its
entirety? What does it matter what the value of EFER is?
