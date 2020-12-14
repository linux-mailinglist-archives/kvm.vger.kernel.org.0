Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753142DA126
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 21:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503020AbgLNUJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 15:09:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502873AbgLNUJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 15:09:41 -0500
X-Gm-Message-State: AOAM532XVEMssn+4LFvz+fnpvd/z8thybKgGqQ4oVFXm4OW1Tc4IGEa7
        6mOpssA+au9pU2KImwxgVhX3ca2PKiMq91cCcdRuuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607976536;
        bh=TKXksRv4ElF9AR3si5HqiL6XEICDaC1eW6DKF5Yk5Nk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QOZ0wCL66CxwTTlRa/NS+nrpGvypaHF5U2FkR7s46wXEqpK5doz0RHRd6vBDWxAW4
         r7o2gYJJ3PZ2JTm256hffJi2nnEYsxtonMmB8SaqDdO1D9KVE8aeCSVRlyIk2MxfVb
         Nq7AzKaiL+jQMb1KbIe0+9vqI49QiXEfr0Jx+ysDldQ2v9nLDsqDDP45jkp6hGqJmh
         OmclkJgtB3plm4vK9rJZP8TDO2KrznTZQIfetLf1jytUj0qxnD0WemIA3orcCM/Nsi
         SdSTrRF7A7izUkbQyZ6pjpcjAsByJhAbPaFoX+rlVa5IdvV17KSt3jHksCfM1hKzwi
         goE8MOceTDNhQ==
X-Google-Smtp-Source: ABdhPJzEJCSPXY2rUKyPY8ufvSSaC7eN1NemTVxh2DRY99B3QhCMzO9GGlPQhf2oE3i3ROdM3GOqRO73gdr+pCkLQzc=
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr6339473wrr.184.1607976534234;
 Mon, 14 Dec 2020 12:08:54 -0800 (PST)
MIME-Version: 1.0
References: <20201214174127.1398114-1-michael.roth@amd.com> <X9e/L3YTAT/N+ljh@google.com>
In-Reply-To: <X9e/L3YTAT/N+ljh@google.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 14 Dec 2020 12:08:42 -0800
X-Gmail-Original-Message-ID: <CALCETrUakTkyR3-Sh+8fKR3wVf_O7Hp=7TOnDP-UnO5B6EjLag@mail.gmail.com>
Message-ID: <CALCETrUakTkyR3-Sh+8fKR3wVf_O7Hp=7TOnDP-UnO5B6EjLag@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Sean Christopherson <seanjc@google.com>
Cc:     Michael Roth <michael.roth@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 14, 2020 at 11:38 AM Sean Christopherson <seanjc@google.com> wrote:
>
> +Andy, who provided a lot of feedback on v1.
>
> >
> >  static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
> > @@ -3507,14 +3503,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >
> >       __svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
>
> Tying in with avoiding svm->host_save_area, what about passing in the PA of the
> save area and doing the vmload in __svm_vcpu_run()?  One less instance of inline
> assembly to stare at...

One potential side benefit is that we wouldn't execute any C code with
the wrong MSR_GS_BASE, which avoids any concerns about
instrumentation, stack protector, or some *SAN feature exploding due
to a percpu memory not working.

--Andy
