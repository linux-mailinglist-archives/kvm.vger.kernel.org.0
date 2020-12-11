Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED78B2D6D19
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 02:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390376AbgLKBMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 20:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732663AbgLKBLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 20:11:49 -0500
X-Gm-Message-State: AOAM530C1yqr5ofDwJSLTWB6aGvHxzXqOa5vi0llwca+DL5VAgj3opBv
        ClapPI285Ks4exCmi8533OH+fNk/dVXmo6PYZ+w4pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607649068;
        bh=dAcBURZEJNez6Uk/ZZK9Cg+yi5MqljnzqZbmRnh7ezo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=n13ek404jsm1IEYttjLpJ6sobRP+dNeooI7cSS6Y077ssx/4YZNxG5aQsZhQBh4Sk
         K39SOBWZwWVnP7FAMZ13Hz/w4ydoNuvrLzpG5XRiBK3Iz83NPZTMJZc+PNPvYcGJdc
         z06hmdYMK4mX8g5qtAj6nO3bMzRzAQwW5qgMATRYk1MlVMrDVqMhNFoJU/NaRqFK6U
         +iC1DMazE+fAj7BLNnLo8RXMbjnnQNiI0h66fTnmBhxs7azL31RM/sYQQcjTGYRiWM
         aQmo0siwUuIMW9sZ+a7S7fn9RAr/E53vYZ7rIhRMVMDUeO3+qqiOgxvbJmm+CZneMW
         3ygYg2pfTomqA==
X-Google-Smtp-Source: ABdhPJxWJqJ7tVadfBvzh8vfSzhT5Ybzv4bEbMb0o6k7sCWgTk3XOc2rB4HsoPsz7pXrFMY85LqzxjqHA2TKWuDsy38=
X-Received: by 2002:adf:e64b:: with SMTP id b11mr10905473wrn.257.1607649066305;
 Thu, 10 Dec 2020 17:11:06 -0800 (PST)
MIME-Version: 1.0
References: <20201210174814.1122585-1-michael.roth@amd.com>
 <CALCETrXo+2LjUt_ObxV+6u6719gTVaMR4-KCrgsjQVRe=xPo+g@mail.gmail.com>
 <160763562772.1125101.13951354991725886671@vm0> <CALCETrV2-WwV+uz99r2RCJx6OADzwxaLxPUVW22wjHoAAN5cSQ@mail.gmail.com>
 <160764771044.1223913.9946447556531152629@vm0>
In-Reply-To: <160764771044.1223913.9946447556531152629@vm0>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 10 Dec 2020 17:10:53 -0800
X-Gmail-Original-Message-ID: <CALCETrVuCZ5itAN3Ns3D04qR1Z_eJiA9=UvyM95zLE076X=JEA@mail.gmail.com>
Message-ID: <CALCETrVuCZ5itAN3Ns3D04qR1Z_eJiA9=UvyM95zLE076X=JEA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Michael Roth <michael.roth@amd.com>
Cc:     Andy Lutomirski <luto@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Dec 10, 2020, at 4:48 PM, Michael Roth <michael.roth@amd.com> wrote:
>

>> I think there are two reasonable ways to do this:
>>
>> 1. VMLOAD before STGI.  This is obviously correct, and it's quite simple=
.
>
> For the testing I ended up putting it immediately after __svm_vcpu_run()
> since that's where we restored GS base previously. Does that seem okay or=
 did
> you have another place in mind?

Looks okay.  If we get an NMI or MCE with the wrong MSR_GS_BASE, then
we are toast, at least on Zen 2 and earlier.  But that spot has GI =3D=3D
0, so this won't happen.

>
>>
>> 2. Save cpu_kernelmode_gs_base(cpu) before VM entry, and restore that
>> value to MSR_GS_BASE using code like this (or its asm equivalent)
>> before STGI:
>>
>> if (static_cpu_has(X86_FEATURE_FSGSBASE))
>>  wrgsbase(base);
>> else
>>  wrmsr...
>>
>> and then VMLOAD in the vcpu_put() path.
>>
>> I can't think of any reason to use loadsegment(), load_gs_index(), or
>> savesegment() at all, nor can I think of any reason to touch
>> MSR_KERNEL_GS_BASE or MSR_FS_BASE.
>
> I'm sort of lumping MSR_GS_BASE restoration in with everything else since=
 I
> don't fully understand what the original was code doing either and was co=
ntent
> to leave it be if we couldn't use VMLOAD to handle it without a performan=
ce
> regression, but since it looks like we can use VMLOAD here instead I agre=
e
> we should just drop it all.

The original code is entirely bogus. Don=E2=80=99t try to hard to understan=
d
how it=E2=80=99s correct =E2=80=94 I=E2=80=99m pretty sure it=E2=80=99s not=
. In fact, I was planning
to write a patch a lot like yours, but I don=E2=80=99t have an SVM-capable =
CPU
to test on.  In general, I suspect that you could delete all these
fields from the structs, see what fails to compile, and fix it pretty
easily.

MSR_GS_BASE is kernel state. (On 32-bit, fs and maybe gs are kernel
state.). Everything else is host *user* state and isn=E2=80=99t touched by
normal kernel code.
