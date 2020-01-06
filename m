Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F82131927
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 21:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgAFURt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 15:17:49 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33096 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgAFURt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 15:17:49 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so49947675ioh.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 12:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ns8GnqwvJg6p4W/syDLUnvePjgs3xerHY20r9Gnc+74=;
        b=clap+ZSlRXw7zp6m90XHVxIDTEjjE9mcltqn7nwhdOy1qAuizA7p54MDYDj3llqhCi
         nJzjNDYwgjjHbTHFIIjbXd9dbOFEWGnu0h83h98/mByZ9oQizwnh0Y5O0zE4RXdBf2E+
         8YrSYyt7ItVEBkpoa5mDBPnC50hGe0Gus6v0OSA9Va1MDXhWqTJxCeN7Cz8XtS890KKT
         NmByMQvlHmLA6ZVfU3rg/ij2JzS7BlH9Exko0AolIcxWcx521GuR3QaU+OCjwIjF9lx9
         /OYjh5668bwPU952Ni87MV/24z2NHt8c/rW0AQ06SmzZtKB/BqiJWof+ycJDMSFnQVrW
         pq6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ns8GnqwvJg6p4W/syDLUnvePjgs3xerHY20r9Gnc+74=;
        b=SvnhwvOW2lGFujuBj/92m6syrqklyven8dMUH12SERcmqIjRtxEe642RqT2ZyPvHOp
         nc1VbrO1zm8AeO6sm6P3T7vPKt8pK3cSifWzHjOQCFtnAaaaH9qUmvXE22McV+mp7SKZ
         Xbg07upMb8uexv8RIHn/5ReSQXon3kGOych1dcYik6hmoNM0Pfncq7nihKI/aypG71Go
         cJIoybceMyezcLmOAKmxaZYsEW8/22EdBdwd1ocbj4xfKMRrHlU6QS0TPZyrPpY26Fod
         9UIAvD3AInmUqkNAFedFeGbqsq+Hk4+1kpBcaR0khoPL26GsSlwSQZv7qfC5dd+xjWg6
         RRXg==
X-Gm-Message-State: APjAAAVNwXDXedOviY6vuo+T548K1UBM8JTUhGgXHEgTYKwPFs4R6JAI
        J/OfHeEX+uBFoD8GVJzMIPg6IUyGCsRObhIpR5y+xQ==
X-Google-Smtp-Source: APXvYqxoZQ+6xjPL1kVSOGms8Zqaps/r0K/FNO33q2IPJVDh7QsN/goJF73XELIobJtwflx3BGbam+GNuwZyL1L5h7E=
X-Received: by 2002:a5e:924c:: with SMTP id z12mr69658990iop.296.1578341868753;
 Mon, 06 Jan 2020 12:17:48 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-6-pomonis@google.com>
In-Reply-To: <20191211204753.242298-6-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:17:37 -0800
Message-ID: <CALMp9eTrGnn7NmBS_-Zpxk0LP4b-NKCEYu46AoEGjH=k_=Hoxw@mail.gmail.com>
Subject: Re: [PATCH v2 05/13] KVM: x86: Protect ioapic_write_indirect() from
 Spectre-v1/L1TF attacks
To:     Marios Pomonis <pomonis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 12:48 PM Marios Pomonis <pomonis@google.com> wrote:
>
> This fixes a Spectre-v1/L1TF vulnerability in ioapic_write_indirect().
> This function contains index computations based on the
> (attacker-controlled) IOREGSEL register.
>
> This patch depends on patch
> "KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks".
>
> Fixes: commit 70f93dae32ac ("KVM: Use temporary variable to shorten lines.")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>
