Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304FF15890C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 04:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBKDw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 22:52:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbgBKDw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 22:52:27 -0500
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 717D020870
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 03:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581393146;
        bh=SwOJ007DlzVaHhAfxj8kTa2Qa2osckocmYAkhDLCzo8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=X45AOYTK/2z2tJBJ2/KPVqQ75Plm5YduM66SbWef3glBImIIrrgcHzxXyiq04edaS
         cZUxrLhCRvpCatPBYmm+UzMLw7V8YEUMFgs0AOiYvg2d+UWSMqkADFsrC37us26jmo
         BJ/kjXsSKupVKlApw9nMkm7Y0+Pq+P5QOHRJk1Ho=
Received: by mail-wm1-f45.google.com with SMTP id p9so1677921wmc.2
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 19:52:26 -0800 (PST)
X-Gm-Message-State: APjAAAUtsWtnni5Tht+y+Pfqwp2kd68OUrYjqmf8KZhHraCwKue+o+Nm
        Yn1wJzuBM6QffQmDyarU9BG1Dkn4VDMsmaHEEj0hRw==
X-Google-Smtp-Source: APXvYqxgbhqU637eohL+mE8vS87HxSjkCSN70aYM1/0pu6EKsQATjp/v+OfI4bu1ySc4Mfq5i4rBqGuW6P+CNAnBMec=
X-Received: by 2002:a1c:bb82:: with SMTP id l124mr2708818wmf.176.1581393144706;
 Mon, 10 Feb 2020 19:52:24 -0800 (PST)
MIME-Version: 1.0
References: <20200203151608.28053-1-xiaoyao.li@intel.com> <20200203151608.28053-6-xiaoyao.li@intel.com>
 <20200203214300.GI19638@linux.intel.com> <829bd606-6852-121f-0d95-e9f1d35a3dde@intel.com>
 <20200204093725.GC14879@hirez.programming.kicks-ass.net>
In-Reply-To: <20200204093725.GC14879@hirez.programming.kicks-ass.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 10 Feb 2020 19:52:13 -0800
X-Gmail-Original-Message-ID: <CALCETrUAsUzqLhhNkLSC2612odskjqPQvj4uXgBOaoBGoCQD0A@mail.gmail.com>
Message-ID: <CALCETrUAsUzqLhhNkLSC2612odskjqPQvj4uXgBOaoBGoCQD0A@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 4, 2020 at 1:37 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Feb 04, 2020 at 05:19:26PM +0800, Xiaoyao Li wrote:
>
> > > > + case MSR_IA32_CORE_CAPS:
> > > > +         if (!msr_info->host_initiated)
> > >
> > > Shouldn't @data be checked against kvm_get_core_capabilities()?
> >
> > Maybe it's for the case that userspace might have the ability to emulate SLD
> > feature? And we usually let userspace set whatever it wants, e.g.,
> > ARCH_CAPABILITIES.
>
> If the 'sq_misc.split_lock' event is sufficiently accurate, I suppose
> the host could use that to emulate the feature at the cost of one
> counter used.

I would be impressed if the event were to fire before executing the
offending split lock.  Wouldn't the best possible result be for it to
fire with RIP pointing to the *next* instruction?  This seems like it
could be quite confusing to a guest.
