Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD41150FF4
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 19:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgBCSuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 13:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbgBCSuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 13:50:05 -0500
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD1F22086A
        for <kvm@vger.kernel.org>; Mon,  3 Feb 2020 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580755805;
        bh=C0fZPAWBrIJDtK8jhtiTFFJ1uvuc8Ih4+sCSwp8+Vek=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H3ihFO0uJ8w5awc+OQDPVydBeo383Bs81cj7V9Mwpcvcaettra6I99G7rSmzjANv7
         c9t2LKgkvU/B8n5CltDMDvH8ve2Tw8sanirzjLZhRLXMNDy69rqTluXxJNrFQc3JGC
         0W7IgrqtrAUo1U17X1dHaQhUgZLrXm/e+olo6Dz4=
Received: by mail-wr1-f46.google.com with SMTP id t2so19684502wrr.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 10:50:04 -0800 (PST)
X-Gm-Message-State: APjAAAXxJQYuBzzlTLnlZxoqVIrYXM/7O6gAjIJAmxi07Z2WpGzfogxm
        +CcZ32N6/b//aQZKsMMGEVOyG8snTXijbPpign+Epw==
X-Google-Smtp-Source: APXvYqw97Dta1dtDK3uxyuW1m/oDzYdLevx7yWoM0DhEnRzU8YjWiCu2RVO0yhkx/iGiKeC2Gi5hM7xL4eXBUrJ5dpQ=
X-Received: by 2002:a5d:4cc9:: with SMTP id c9mr16805688wrt.70.1580755803128;
 Mon, 03 Feb 2020 10:50:03 -0800 (PST)
MIME-Version: 1.0
References: <b2e2310d-2228-45c2-8174-048e18a46bb6@intel.com>
 <A2622E15-756D-434D-AF64-4F67781C0A74@amacapital.net> <0fe84cd6-dac0-2241-59e5-84cb83b7c42b@intel.com>
In-Reply-To: <0fe84cd6-dac0-2241-59e5-84cb83b7c42b@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 3 Feb 2020 10:49:50 -0800
X-Gmail-Original-Message-ID: <CALCETrXVNBhBCpcQaxxtc9zK3W9_NnM2_ttjj-A=oa6drsSp+w@mail.gmail.com>
Message-ID: <CALCETrXVNBhBCpcQaxxtc9zK3W9_NnM2_ttjj-A=oa6drsSp+w@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 1, 2020 at 8:33 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 2/2/2020 1:56 AM, Andy Lutomirski wrote:
> >
> >
> > There are two independent problems here.  First, SLD *can=E2=80=99t* be=
 virtualized sanely because it=E2=80=99s per-core not per-thread.
>
> Sadly, it's the fact we cannot change. So it's better virtualized only
> when SMT is disabled to make thing simple.
>
> > Second, most users *won=E2=80=99t want* to virtualize it correctly even=
 if they could: if a guest is allowed to do split locks, it can DoS the sys=
tem.
>
> To avoid DoS attack, it must use sld_fatal mode. In this case, guest are
> forbidden to do split locks.
>
> > So I think there should be an architectural way to tell a guest that SL=
D is on whether it likes it or not. And the guest, if booted with sld=3Dwar=
n, can print a message saying =E2=80=9Chaha, actually SLD is fatal=E2=80=9D=
 and carry on.
>
> OK. Let me sort it out.
>
> If SMT is disabled/unsupported, so KVM advertises SLD feature to guest.
> below are all the case:
>
> -----------------------------------------------------------------------
> Host    Guest   Guest behavior
> -----------------------------------------------------------------------
> 1. off          same as in bare metal
> -----------------------------------------------------------------------
> 2. warn off     allow guest do split lock (for old guest):
>                 hardware bit set initially, once split lock
>                 happens, clear hardware bit when vcpu is running
>                 So, it's the same as in bare metal
>
> 3.      warn    1. user space: get #AC, then clear MSR bit, but
>                    hardware bit is not cleared, #AC again, finally
>                    clear hardware bit when vcpu is running.
>                    So it's somehow the same as in bare-metal

Well, kind of, except that the warning is inaccurate -- there is no
guarantee that the hardware bit will be set at all when the guest is
running.  This doesn't sound *that* bad, but it does mean that the
guest doesn't get the degree of DoS protection it thinks it's getting.

My inclination is that, the host mode is warn, then SLD should not be
exposed to the guest at all and the host should fully handle it.

>
>                 2. kernel: same as in bare metal.
>
> 4.      fatal   same as in bare metal
> ----------------------------------------------------------------------
> 5.fatal off     guest is killed when split lock,
>                 or forward #AC to guest, this way guest gets an
>                 unexpected #AC

Killing the guest seems like the right choice.  But see below -- this
is not ideal if the guest is new.

>
> 6.      warn    1. user space: get #AC, then clear MSR bit, but
>                    hardware bit is not cleared, #AC again,
>                    finally guest is killed, or KVM forwards #AC
>                    to guest then guest gets an unexpected #AC.
>                 2. kernel: same as in bare metal, call die();
>
> 7.      fatal   same as in bare metal
> ----------------------------------------------------------------------
>
> Based on the table above, if we want guest has same behavior as in bare
> metal, we can set host to sld_warn mode.

I don't think this is correct.  If the host is in warn mode, then the
guest behavior will be erratic.  I'm not sure it makes sense for KVM
to expose such erratic behavior to the guest.

> If we want prevent DoS from guest, we should set host to sld_fatal mode.
>
>
> Now, let's analysis what if there is an architectural way to tell a
> guest that SLD is forced on. Assume it's a SLD_forced_on cpuid bit.
>
> - Host is sld_off, SLD_forced_on cpuid bit is not set, no change for
>    case #1

Agreed.

>
> - Host is sld_fatal, SLD_forced_on cpuid bit must be set:
>         - if guest is SLD-aware, guest is supposed to only use fatal
>           mode that goes to case #7. And guest is not recommended
>           using warn mode. if guest persists, it goes to case #6

Agreed, although I'm not sure I fully understand your #6 suggestion.
If the host is fatal and the guest is SLD-aware, then #AC should be
forwarded to the guest and the guest should act as if sld is fatal.
If the guest is booted with sld=3Doff or sld=3Dwarn, the guest should log
a message saying that the configuration is unsupported and act as
though sld=3Dfatal.

>
>         - if guest is not SLD-aware, maybe it's an old guest or it's a
>           malicious guest that pretends not SLD-aware, it goes to
>           case #5.

By case 5 you mean kill the guest?

>
> - Host is sld_warn, we have two choice
>         - set SLD_forced_on cpuid bit, it's the same as host is fatal.
>         - not set SLD_force_on_cpuid bit, it's the same as case #2,#3,#4

I think the right solution is to treat the guest just like host
usermode: guest never gets killed and never gets #AC. Instead the
*host* logs a warning.

>
> So I think introducing an architectural way to tell a guest that SLD is
> forced on can make the only difference is that, there is a way to tell
> guest not to use warn mode, thus eliminating case #6.

It also tells the guest not to use off mode.  Also, we don't know what
non-Linux guests are going to do.
