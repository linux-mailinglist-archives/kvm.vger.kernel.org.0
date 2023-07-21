Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC66B75D0BA
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 19:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjGURh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 13:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjGURh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 13:37:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2748110
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 10:37:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b8a7734734so13002825ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 10:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689961044; x=1690565844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U27m05eGSBK5TepOrN4F4KtiNak4c4lxWiiYTBxsdZA=;
        b=co+gfhIz5/NW5vs/2Rt3SPX1epn1hB1tpZFLn7EJfRZv/vmB0L/zAv9yVBCPOdaOrO
         RGzlooXQCdpc50NBl83SNi6nQaaH+fQ/fTxM6RVbGZyRnnkN9Zf7eYwG3GPZ1U8I4zjN
         OSKLM6B6WAYvsBOBHcJVbT8bMJS1NHi2EUVLHJwZjJPGY1uMV+afVb0qG34tF8Nhh4Ig
         6OkaGDlcIVo7SX4JxcMP2ayklLKKcic7n/6a8i45POJX/xxnjerxBog8dN3OzjR7fr/q
         lu5VolWlSlZHTRV4UukTf6VrjaFvFtGU3sorl3y+z2Q4GC5CPBXTvJWQ/6aRU82MvO6T
         qM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689961044; x=1690565844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U27m05eGSBK5TepOrN4F4KtiNak4c4lxWiiYTBxsdZA=;
        b=eZMZwvfW/oJEKjusuEkkHBfZG2svpoKIwWvKpqhP8HREB9iMWI2HtTSB+FnBgsmnhE
         Fc5jgmfFLC/wyHNmzW85PxTRCzN3CyFDBnb4Kmh8Ltedni4sHRjGOjzsibk/KGeF1ist
         kO6dYwqSrOp4B5aejg/UYgKjvcf1PR92P4hMmCfAWYjIKrNTNsQ0XXZiLdlEjv/CRObh
         C/NOgb/BPLLpQdNeHJnPGKyLXg5jRpaxUNrc9Ei9u8gZI+pZcDE8Lju4B57zqpFhfj4H
         jn0DhY1dJazk/FREE8jTL26QSUqmHk3owtRcW/88nTV37dixlFTFwxTtHwQRQrjmhV1V
         sjVw==
X-Gm-Message-State: ABy/qLafdCnjm0ZCQLcxsGwty4G9C02uLSNRzkSWW5lk3cY7wq8V8ENR
        Y5gUrQcQeORfNCAxbAL9zj5Advok/eM=
X-Google-Smtp-Source: APBJJlH00qM/FbwDSKPdDQa2qPEVgrDIt3MR3RfpZM/V9Gp+JmYa9K6Lghy1uz20fCuZD29KRzZnjnrKSLQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c9:b0:1b9:df8f:888c with SMTP id
 e9-20020a17090301c900b001b9df8f888cmr9478plh.8.1689961044214; Fri, 21 Jul
 2023 10:37:24 -0700 (PDT)
Date:   Fri, 21 Jul 2023 10:37:22 -0700
In-Reply-To: <20230721143407.2654728-1-amaan.cheval@gmail.com>
Mime-Version: 1.0
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com>
Message-ID: <ZLrCUkwot/yiVC8T@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Amaan Cheval <amaan.cheval@gmail.com>
Cc:     brak@gameservers.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023, Amaan Cheval wrote:
> I've also run a `function_graph` trace on some of the affected hosts, if you
> think it might be helpful to have a look at that to see what the host kernel
> might be doing while the guests are looping on EPT_VIOLATIONs. Nothing obvious
> stands out to me right now.

It wouldn't hurt to see it.

> We suspected KSM briefly, but ruled that out by turning KSM off and unmerging
> KSM pages - after doing that, a guest VM still locked up / started looping
> EPT_VIOLATIONS (like in Brian's original email), so it's unlikely this is KSM specific.
> 
> Another interesting observation we made was that when we migrate a guest to a
> different host, the guest _stays_ locked up and throws EPT violations on the new
> host as well 

Ooh, that's *very* interesting.  That pretty much rules out memslot and mmu_notifier
issues.

>- so it's unlikely the issue is in the guest kernel itself (since
> we see it across guest operating systems), but perhaps the host kernel is
> messing the state of the guest kernel up in a way that keeps it locked up after
> migrating as well?
> 
> If you have any thoughts on anything else to try, let me know!

Good news and bad news.  Good news: I have a plausible theory as to what might be
going wrong.  Bad news: if my theory is correct, our princess is in another castle
(the bug isn't in KVM).

One of the scenario where KVM retries page faults is if KVM asynchronously faults-in
the host backing page.  If faulting in the page would require I/O, e.g. because
it's been swapped out, instead of synchronously doing the I/O on the vCPU task,
KVM uses a workqueue to fault in the page and immediately resumes the guest.

There are a variety of conditions that must be met to try an async page fault, but
assuming you aren't disable HLT VM-Exit, i.e. aren't letting the guest execute HLT,
it really just boils down to IRQs being enabled in the guest, which looking at the
traces is pretty much guaranteed to be true.

What's _supposed_ to happen is that async_pf_execute() successfully faults in the
page via get_user_pages_remote(), and then KVM installs a mapping for the guest
either in kvm_arch_async_page_ready() or by resuming the guest and cleanly handling
the retried guest page fault.

What I suspect is happening is that get_user_pages_remote() fails for some reason,
i.e. the workqueue doesn't fault in the page, and the vCPU gets stuck trying to
fault in a page that can't be faulted in for whatever reason.  AFAICT, nothing in
KVM will actually complain or even surface the problem in tracepoints (yeah, that's
not good).

Circling back to the bad news, if that's indeed what's happening, it likely means
there's a bug somewhere else in the stack.  E.g. it could be core mm/, might be
in the block layer, in swap, possibly in the exact filesystem you're using, etc.

Note, there's also a paravirt extension to async #PFs, where instead of putting
the vCPU into a synthetic halted state, KVM instead *may* inject a synthetic #PF
into the guest, e.g. so that the guest can go run a different task while the
faulting task is blocked.  But this really is just a note, guest enabling of PV
async #PF shouldn't actually matter, again assuming my theory is correct.

To mostly confirm this is likely what's happening, can you enable all of the async
#PF tracepoints in KVM?  The exact tracepoints might vary dependending on which kernel
version you're running, just enable everything with "async" in the name, e.g.

  # ls -1 /sys/kernel/debug/tracing/events/kvm | grep async
  kvm_async_pf_completed/
  kvm_async_pf_not_present/
  kvm_async_pf_ready/
  kvm_async_pf_repeated_fault/
  kvm_try_async_get_page/

If kvm_try_async_get_page() is more or less keeping pace with the "pf_taken" stat,
then this is likely what's happening.

And then to really confirm, this small bpf program will yell if get_user_pages_remote()
fails when attempting get a single page (which is always the case for KVM's async
#PF usage).

FWIW, get_user_pages_remote() isn't used all that much, e.g. when running a VM in
my, KVM is the only user.  So you can likely aggressively instrument
get_user_pages_remote() via bpf without major problems, or maybe even assume that
any call is from KVM.

$ tail gup_remote.bt 
kretfunc:get_user_pages_remote
{
        if ( args->nr_pages == 1 && retval != 1 ) {
                printf("Failed remote gup() on address %lx, ret = %d\n", args->start, retval);
        }
}

