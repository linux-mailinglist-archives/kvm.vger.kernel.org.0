Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2AF5FE004
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 15:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfKOO0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 09:26:10 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37992 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfKOO0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 09:26:09 -0500
Received: by mail-lj1-f196.google.com with SMTP id v8so10902130ljh.5
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 06:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2s4PTa8DL16YJ33v+TIOuBj4ZPP4D1YasYLzCNI294=;
        b=vcgq70ScYIQ4fAj7N+yf/SeviKuTfD3VdVHSpojWlpfhgOtDWSKSEKJExBYB4zq1Ui
         2woEkl2MXVI8uYkPP6gr9/KJjSSoTMwtm4ShQphBSIfQGoU+yQfyEGg6ahz/O+XsHimR
         MeGgKdLsEmukn9/R2pK3hut+sSm9sjGp87oZgz2RGS+iX8pn2cloEXM36vR1bxxvVWR3
         7zmw5whrNLqls2Laz610kUjf5dWtjnv7GUZtrMyeXUtEVcdl4DUCpcJREKdQvUo/4x/V
         cxXqMqcjP4byISLLg05l81UtFsmB2mOHt51P7foskWGol/vMcJNfPMOiqiX456kRb6cE
         p9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2s4PTa8DL16YJ33v+TIOuBj4ZPP4D1YasYLzCNI294=;
        b=jzuMAXcS2iOw81+h8wvlDH7tWZq6UjnpiQVjmX09y2wJ5X0kmHk0U/05rj0PbnxlPT
         t9zPvLc/bOfqw+jmMeha3y0gcoGAps2UwINYWn0WvbPVjFx6k+y4GC5QIUX9zdd398LU
         ssNwZ8X72Nnquql0KdFj90NIaf6tVIqhPUEM+DdJBQ2U6MYl1Pfonm1dNwmTQQdDI4i0
         dmng5sEIUmSxd4ufHz33q1CgCtFdAZihEI49f2w6hbrC5R9mk6XqduVDdAnFGcu8WkIj
         ipvwXUrH8adgMVRT2iL6etwy+87Q4KiAaJTVJrFQYuomRHyIxlzMYhMMerfv/tFOOlCR
         y3sQ==
X-Gm-Message-State: APjAAAUVJUrO/V+vSn93nluuO5YktWY1PqluqCvCE5xj9oExUAsXzZrz
        XKAvr6waJfmJ/G6r8Q4/WWQHRMU0SGzZVU6o9RPjDA==
X-Google-Smtp-Source: APXvYqz5BbCZfgz8OLL95cZUzz5y0HzOvWWrdaCgtKlobYh43CLfzhBdTXq6RY1HV4Rpv+JlHSluUQIZqo3XKLiUk/s=
X-Received: by 2002:a2e:b0d3:: with SMTP id g19mr11026236ljl.135.1573827967158;
 Fri, 15 Nov 2019 06:26:07 -0800 (PST)
MIME-Version: 1.0
References: <20191108051439.185635-1-aaronlewis@google.com> <52b9e145-9cc6-a1b5-fee6-c3afe79e9480@redhat.com>
In-Reply-To: <52b9e145-9cc6-a1b5-fee6-c3afe79e9480@redhat.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 15 Nov 2019 06:25:56 -0800
Message-ID: <CAAAPnDHQSCGjLX252Zj7UDWjQQ9uKYC9UTmCWx2HJ4Q+u-aObw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Add support for capturing the highest observable
 L2 TSC
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 2:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 08/11/19 06:14, Aaron Lewis wrote:
> > The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
> > vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
> > TSC value that might have been observed by L2 prior to VM-exit. The
> > current implementation does not capture a very tight bound on this
> > value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to the
> > vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 VM-exit
> > MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
> > during the emulation of an L2->L1 VM-exit, special-case the
> > IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
> > VM-exit MSR-store area to derive the value to be stored in the vmcs12
> > VM-exit MSR-store area.
> >
> > v3 -> v4:
> >  - Squash the final commit with the previous one used to prepare the MSR-store
> >    area.  There is no need for this split after all.
> >
> > v2 -> v3:
> >  - Rename NR_MSR_ENTRIES to NR_LOADSAVE_MSRS
> >  - Pull setup code for preparing the MSR-store area out of the final commit and
> >    put it in it's own commit (4/5).
> >  - Export vmx_find_msr_index() in the final commit instead of in commit 3/5 as
> >    it isn't until the final commit that we actually use it.
> >
> > v1 -> v2:
> >  - Rename function nested_vmx_get_msr_value() to
> >    nested_vmx_get_vmexit_msr_value().
> >  - Remove unneeded tag 'Change-Id' from commit messages.
> >
> > Aaron Lewis (4):
> >   kvm: nested: Introduce read_and_check_msr_entry()
> >   kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_LOADSTORE_MSRS
> >   kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
> >   KVM: nVMX: Add support for capturing highest observable L2 TSC
> >
> >  arch/x86/kvm/vmx/nested.c | 136 ++++++++++++++++++++++++++++++++------
> >  arch/x86/kvm/vmx/vmx.c    |  14 ++--
> >  arch/x86/kvm/vmx/vmx.h    |   9 ++-
> >  3 files changed, 131 insertions(+), 28 deletions(-)
> >
>
> Queued, but it would be good to have a testcase for this, either for
> kvm-unit-tests or for tools/testing/selftests/kvm.
>
> Paolo
>

Agreed.  I have some test cases in kvm-unit-tests for this code that
I've been using to test these changes locally, however, they would
fail upstream without "[kvm-unit-tests PATCH] x86: Fix the register
order to match struct regs" being taken first.  I'll ping that patch
again.
