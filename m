Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639DD2A3273
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgKBSBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgKBSBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 13:01:30 -0500
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97BE3223B0
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604340089;
        bh=Lu2awJXBNnFGXdwNkoMmBcrestweRIqVSRAv+UFn8UU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vcIv/F0bRxbMe9GLXTcLzUL8Cks48Z/SkPGRo+er28CTkL/CiTLby9oihAEvDTclh
         jg14ZgzV4tKtRdEJa0N71mgyjPX5KwE1lEFymgs9uLv/5ZgVNR6GFTBW378Czq7PmC
         yg2cQ6YW/MXj99bOlIN2WXH8+uzPGlbVDE1W1jho=
Received: by mail-wm1-f50.google.com with SMTP id c18so10301484wme.2
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 10:01:29 -0800 (PST)
X-Gm-Message-State: AOAM531GX3a8076zwHRoqfziuy+lroxO3QWihwQZ39EXzrG1uUUzKWDs
        tesRmWyUOFJLHCdp0KYcgY31E5JMB4Mu2KZarQErNw==
X-Google-Smtp-Source: ABdhPJyln63jWXsy5MlOw0cHUi34pZw5XKqEPGLGprBb8+oOXIyCAX0XVcUwGjLfWdWXCBK8fKbgfIT+KYJJrTdQqng=
X-Received: by 2002:a1c:7213:: with SMTP id n19mr11246737wmc.36.1604340087908;
 Mon, 02 Nov 2020 10:01:27 -0800 (PST)
MIME-Version: 1.0
References: <20201102061445.191638-1-tao3.xu@intel.com> <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
 <20201102173130.GC21563@linux.intel.com>
In-Reply-To: <20201102173130.GC21563@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 2 Nov 2020 10:01:16 -0800
X-Gmail-Original-Message-ID: <CALCETrV0ZsTcQKVCPPSKHnuVgERMC0x86G5y_6E5Rhf=h5JzsA@mail.gmail.com>
Message-ID: <CALCETrV0ZsTcQKVCPPSKHnuVgERMC0x86G5y_6E5Rhf=h5JzsA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 2, 2020 at 9:31 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Nov 02, 2020 at 08:43:30AM -0800, Andy Lutomirski wrote:
> > On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
> > > 2. Another patch to disable interception of #DB and #AC when notify
> > > VM-Exiting is enabled.
> >
> > Whoa there.
> >
> > A VM control that says "hey, CPU, if you messed up and livelocked for
> > a long time, please break out of the loop" is not a substitute for
> > fixing the livelocks.  So I don't think you get do disable
> > interception of #DB and #AC.
>
> I think that can be incorporated into a module param, i.e. let the platform
> owner decide which tool(s) they want to use to mitigate the legacy architecture
> flaws.

What's the point?  Surely the kernel should reliably mitigate the
flaw, and the kernel should decide how to do so.

>
> > I also think you should print a loud warning
>
> I'm not so sure on this one, e.g. userspace could just spin up a new instance
> if its malicious guest and spam the kernel log.

pr_warn_once()?  If this triggers, it's a *bug*, right?  Kernel or CPU.

>
> > and have some intelligent handling when this new exit triggers.
>
> We discussed something similar in the context of the new bus lock VM-Exit.  I
> don't know that it makes sense to try and add intelligence into the kernel.
> In many use cases, e.g. clouds, the userspace VMM is trusted (inasmuch as
> userspace can be trusted), while the guest is completely untrusted.  Reporting
> the error to userspace and letting the userspace stack take action is likely
> preferable to doing something fancy in the kernel.
>
>
> Tao, this patch should probably be tagged RFC, at least until we can experiment
> with the threshold on real silicon.  KVM and kernel behavior may depend on the
> accuracy of detecting actual attacks, e.g. if we can set a threshold that has
> zero false negatives and near-zero false postives, then it probably makes sense
> to be more assertive in how such VM-Exits are reported and logged.

If you can actually find a threshold that reliably mitigates the bug
and does not allow a guest to cause undesirably large latency in the
host, then fine.  1/10 if a tick is way too long, I think.
