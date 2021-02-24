Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38C2324305
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 18:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhBXRN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 12:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbhBXRNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 12:13:51 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A248C061574
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 09:13:10 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id z128so2822013qkc.12
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 09:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtACNUPOTKFJMR28JTicXGvA4n2KurcOaH8kXxHNFz0=;
        b=eI6oM53GsMawJK3MX0YJNSdvTX2/qszUFCKStACoOBqn20F5iStdT+dsZMLCJuAB/n
         wip1Khr9NF3AtCXg0a6oIucpojk+uRWMLq5AdLKQywyo/WeOxgB6vzTBbFC/Gj8XdBo4
         cVJs9ZhZQmV69Hi+YDKxkUCL14U++5ffXxHE8OFK237hQwOCmA/7zmyJmIEMHkLCFUBX
         LPSxM/IDjghuIFELD5+KVBwKhhP7C0r4UAs+u7cwTxmrZrh9MSwTtUCzlcJhMf+5PhJ4
         hsu9WYwjWv2PQZmQndQHzticH0NfFPeY8Y8DMvrVraQNjMHgYVAeYSv7Uot/wY2Jzfrf
         mM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtACNUPOTKFJMR28JTicXGvA4n2KurcOaH8kXxHNFz0=;
        b=Vi/FSnOWw9nvaxGuEu58SurpbROqr02AU/T0HJnQFauaOo5UDRXSDS9elDprdCBgIP
         GS/1auHgyxFZwkbGrFp3nItZywds4z0AOe/DJRT4W1qmJaVm5+/yj6opcQyzJ5sLMpJj
         nC5tPOVMEl9+oamF/F4sED7AoGNFw54Dq95QddGKepXzsrizsDXzJBYFtZIPHTxY1vSS
         BvhpDZVbmfhoFXusBdtB7XCqb4XxR4yhOzr5hzQvGh5g0SqXHNQ8IhVxTYgKJjJ+SKTX
         p9h2Mq1rlucosfdudUNUrTl7B5sGQIL1NNR+Z82FsMAzKmepNKRT+2OxGohmwJ68Lzkn
         QVaA==
X-Gm-Message-State: AOAM531SQ/Y9HhFHWGIqXrTtihop5fg1JWpc6Q8MRswMzpj4+Dd5oycR
        EKl7UOOh0rRmDrXnwxT7BZs68523hzD2bmUy3/R9Kg==
X-Google-Smtp-Source: ABdhPJx0PiOREpVR7i9mJVHqO8PGscLL9eaNv3hBd8dNLOLqkCfG1mLQOV7o7VrvBi+IfrAMCb1o5hJFRJ10QHVIUoo=
X-Received: by 2002:a37:a757:: with SMTP id q84mr31057613qke.501.1614186789469;
 Wed, 24 Feb 2021 09:13:09 -0800 (PST)
MIME-Version: 1.0
References: <0000000000007ff56205ba985b60@google.com> <00000000000004e7d105bc091e06@google.com>
 <20210224122710.GB20344@zn.tnic>
In-Reply-To: <20210224122710.GB20344@zn.tnic>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 24 Feb 2021 18:12:57 +0100
Message-ID: <CACT4Y+ZaGOpJ1+dxfTVWhNuV5hFJmx=HgPqVf6bqWE==7PeFFQ@mail.gmail.com>
Subject: Re: general protection fault in vmx_vcpu_run (2)
To:     Borislav Petkov <bp@alien8.de>
Cc:     syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 1:27 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Feb 23, 2021 at 03:17:07PM -0800, syzbot wrote:
> > syzbot has bisected this issue to:
> >
> > commit 167dcfc08b0b1f964ea95d410aa496fd78adf475
> > Author: Lorenzo Stoakes <lstoakes@gmail.com>
> > Date:   Tue Dec 15 20:56:41 2020 +0000
> >
> >     x86/mm: Increase pgt_buf size for 5-level page tables
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13fe3ea8d00000
> > start commit:   a99163e9 Merge tag 'devicetree-for-5.12' of git://git.kern..
> > git tree:       upstream
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=10013ea8d00000
>
> No oops here.
>
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17fe3ea8d00000
>
> Nothing special here too.
>
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=49116074dd53b631
>
> Tried this on two boxes, the Intel one doesn't even boot with that
> config - and it is pretty standard one - and on the AMD one the
> reproducer doesn't trigger anything. It probably won't because the GP
> is in vmx_vcpu_run() but since the ioctls were doing something with
> IRQCHIP, I thought it is probably vendor-agnostic.
>
> So, all in all, I could use some more info on how you're reproducing and
> maybe you could show the oops too.

Hi Boris,

Looking at the bisection log, the bisection was distracted by something else.
You can always find the original reported issue over the dashboard link:
https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef
or on lore:
https://lore.kernel.org/lkml/0000000000007ff56205ba985b60@google.com/
