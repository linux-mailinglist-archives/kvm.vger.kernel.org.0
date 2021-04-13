Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E1935E63F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhDMSYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbhDMSYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:24:34 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ACFC061756
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:24:13 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id ef17so2898041qvb.0
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kOiJzunVd05mqamt/5TGLR6Y6fd83AHptXCwJ4Xqk20=;
        b=XFVCecc5SaXMXkEtMSOm6hS5wZ10POOPoNVf6wtWlKfFJsuYEYKWxhzSt0+b/fVFg5
         j70FPau57jAGTGNQ3+9tA9h9ZoO7yhMw9fFhKY3ccf2fbxJjT4KC68lzeAS+4cn3HMGB
         wp5PzotUQA4HOmRLYGnF6lGyWvjkDUaH9c4W68ZoCoNauDoc4V9TStZcf3ER3GSgi2B8
         TAKRg/N1syJIMdjgHR6v6YGmBieKFHBRue3kOx9W/YALVuUYFVfV04eS3w2NY9xdW8aO
         3ft/9Hvx7suI6YOOuwBV33K9HKwN2ojD3DmQGMoZB4GKqS/qhxJBAMFiF7xo1WSXfU70
         peYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kOiJzunVd05mqamt/5TGLR6Y6fd83AHptXCwJ4Xqk20=;
        b=ryj2xfqmZSax+Iy7sxICDw+RFMM+lwLdKMp4g6ogAEsdyxtbFki05x4lQ12Lx8fEKL
         3Du3LO+7uy4OR0yELr9lVTgDYrQBG7NJTr+ZrvS8oc/ALULeHBHFWJILjNoEz4T6x6y/
         Q2eIiaT2HlQ9N69ab5tfPi3pQgrCMDTQDx/F2dOxqgeJ3syTqyQfnnPCFAkKJwRbS2Bd
         Y/EYlwJ02HFgykC0x2aimCJ0tp9b4gkIdKKaFG8aUIu0rw+0J1a2JhNEILO+ETotCg/K
         AKsV4SsNOeH2jbFZnLrMv0PWMP17nYyu6wLmBD1lTJxb+iNmft2OKX6TtvKtMTWJboMq
         nc8Q==
X-Gm-Message-State: AOAM5330yZtJnqIf1rSPE24rasMQXClgOsbikjdKkg1CrwSUHDNxsJmL
        p85y8pcV9AChEp6Kk8TRUJ5w+BCWeVQbbCCwTQORyA==
X-Google-Smtp-Source: ABdhPJw6yF83WYbBJZbmO8yDMBaKSylZ7lchp4a3dBmw4v5MoYL6NrNQOEUYGEgo1fjifejUv/nkR/RD81DbNlucA38=
X-Received: by 2002:a0c:8421:: with SMTP id l30mr21579057qva.23.1618338252752;
 Tue, 13 Apr 2021 11:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ae236f05bfde0678@google.com> <20210413134147.54556d9d@gandalf.local.home>
 <20210413134314.16068eeb@gandalf.local.home>
In-Reply-To: <20210413134314.16068eeb@gandalf.local.home>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 13 Apr 2021 20:24:00 +0200
Message-ID: <CACT4Y+ZrkE=ZKKncTOJRJgOTNfU8PGz=k+8V+0602ftTCHkc6Q@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in del_gendisk
To:     Steven Rostedt <rostedt@goodmis.org>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     syzbot <syzbot+61e04e51b7ac86930589@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, masahiroy@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        rafael.j.wysocki@intel.com,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 7:43 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 13 Apr 2021 13:41:47 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > As the below splats look like it has nothing to do with this patch, and
> > this patch will add a WARN() if there's broken logic somewhere, I bet the
> > bisect got confused (if it is automated and does a panic_on_warning),
> > because it will panic for broken code that his patch detects.
> >
> > That is, the bisect was confused because it was triggering on two different
> > issues. One that triggered the reported splat below, and another that this
> > commit detects and warns on.
>
> Is it possible to update the the bisect to make sure that if it is failing
> on warnings, to make sure the warnings are somewhat related, before decided
> that its the same bug?

It does not seem to be feasible, bugs manifest differently in both
space and time. Also even if we somehow conclude the crash we see is
different, it says nothing about the original bug. For more data see:
https://groups.google.com/g/syzkaller/c/sR8aAXaWEF4/m/tTWYRgvmAwAJ
