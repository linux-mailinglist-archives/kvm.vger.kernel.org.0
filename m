Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327FD581CC1
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 02:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiG0A0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 20:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiG0A0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 20:26:04 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB7C32EEA;
        Tue, 26 Jul 2022 17:26:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c139so14696874pfc.2;
        Tue, 26 Jul 2022 17:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jf6QAz2nVfnBI0fnKRxxMlR+59XYLFAdw/tdsgL99ag=;
        b=CKBLT5/jFohLTUaBLrLSOgxvFUVtsdpSeZMrFHRS/ksGOHyZ1YaHWlBLkv8h2TEQbE
         ZWIePDcyUiZ6MD77U5r2QS+80VwTBH9CEknw44hh2qb8TmjSpponEIz87b5GkXRnJ2Tg
         g8yqRXnjKK0kL6ohjhee9D44xm/oEbXXpCMpcJc2HcNNhMl348Laz7Hh0zhGU0IDOZxS
         CKtxOzc+Nyfxh78sxxD+1MU/iXJR185Sj1m5PoMm8lNRNW8T2OD+GIizRfm/vXh8aStu
         0WIlxaU3e1OlOGhWZHlPvo8o5BuPdLfodMQBXNCiOYM7wKIGHUX1XvgrQxiS1A2JmNva
         4eIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jf6QAz2nVfnBI0fnKRxxMlR+59XYLFAdw/tdsgL99ag=;
        b=aHcpkkfQzW0kuHYACUEEtERHGVy+/nRyZcmrgiUsNy+ksuuDiPmSbjPzjA3eJ6Oxff
         o/DhJBb7nNOjQRDf4w6xozl7kgI329wizrqgXn34NWcOHtq2nTrcNOTyvuYN5vWcj/Em
         q2RFmj4SovybSmJSgjcdpLmSyYQL5+aUvbj3h6ri68CvXFKIgo5+C9S+ZXY4PVSHtxwg
         TQ8ZL5Nw91/WDOfBBRXReNg2mD24Am1nhEx7ITqjHs2QhbgUdHmhphxcc4WVM3pluDum
         cI791p5RCoHUGZJqOnCjDNYm5m1pABAUoSL4FEI8RxFe/CRbvz6LjtI1CCCu49tdy+wg
         3r1g==
X-Gm-Message-State: AJIora8lgBQuG9JyDrnEvZ8oCU/IEMS6Otn56yZ6XAK+gkOlO4UZmYIh
        d0YZ+shRbcxOI+gfXqtgSHs=
X-Google-Smtp-Source: AGRyM1shjcgFeFy9LM7LyrQ3tclfQT3iFtGy9QNvp9vQtiC+WiPem4Oe4Rr08rs9TIsYB7gAsSwKPw==
X-Received: by 2002:a05:6a00:1a86:b0:52a:d419:9552 with SMTP id e6-20020a056a001a8600b0052ad4199552mr19708455pfv.70.1658881562671;
        Tue, 26 Jul 2022 17:26:02 -0700 (PDT)
Received: from gmail.com ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902ceca00b0016d5e4d29f8sm3898287plg.9.2022.07.26.17.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 17:26:01 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:25:59 -0700
From:   Andrei Vagin <avagin@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrei Vagin <avagin@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
Message-ID: <YuCGF/7sOPmSoFSa@gmail.com>
References: <20220722230241.1944655-1-avagin@google.com>
 <Yts1tUfPxdPH5XGs@google.com>
 <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com>
 <YuAD6qY+F2nuGm62@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <YuAD6qY+F2nuGm62@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26, 2022 at 03:10:34PM +0000, Sean Christopherson wrote:
> On Tue, Jul 26, 2022, Andrei Vagin wrote:
> > On Fri, Jul 22, 2022 at 4:41 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > +x86 maintainers, patch 1 most definitely needs acceptance from folks beyond KVM.
> > >
> > > On Fri, Jul 22, 2022, Andrei Vagin wrote:
> > > > Another option is the KVM platform. In this case, the Sentry (gVisor
> > > > kernel) can run in a guest ring0 and create/manage multiple address
> > > > spaces. Its performance is much better than the ptrace one, but it is
> > > > still not great compared with the native performance. This change
> > > > optimizes the most critical part, which is the syscall overhead.
> > >
> > > What exactly is the source of the syscall overhead,
> > 
> > Here are perf traces for two cases: when "guest" syscalls are executed via
> > hypercalls and when syscalls are executed by the user-space VMM:
> > https://gist.github.com/avagin/f50a6d569440c9ae382281448c187f4e
> > 
> > And here are two tests that I use to collect these traces:
> > https://github.com/avagin/linux-task-diag/commit/4e19c7007bec6a15645025c337f2e85689b81f99
> > 
> > If we compare these traces, we can find that in the second case, we spend extra
> > time in vmx_prepare_switch_to_guest, fpu_swap_kvm_fpstate, vcpu_put,
> > syscall_exit_to_user_mode.
> 
> So of those, I think the only path a robust implementation can actually avoid,
> without significantly whittling down the allowed set of syscalls, is
> syscall_exit_to_user_mode().
> 
> The bulk of vcpu_put() is vmx_prepare_switch_to_host(), and KVM needs to run
> through that before calling out of KVM.  E.g. prctrl(ARCH_GET_GS) will read the
> wrong GS.base if MSR_KERNEL_GS_BASE isn't restored.  And that necessitates
> calling vmx_prepare_switch_to_guest() when resuming the vCPU.
> 
> FPU state, i.e. fpu_swap_kvm_fpstate() is likely a similar story, there's bound
> to be a syscall that accesses user FPU state and will do the wrong thing if guest
> state is loaded.
> 
> For gVisor, that's all presumably a non-issue because it uses a small set of
> syscalls (or has guest==host state?), but for a common KVM feature it's problematic.


I think the number of system calls that touch a state that is
intersected with KVM is very limited and we can blocklist all of them.
Another option is to have an allow list of system calls to be sure that
we don't miss anything.

> 
> > > and what alternatives have been explored?  Making arbitrary syscalls from
> > > within KVM is mildly terrifying.
> > 
> > "mildly terrifying" is a good sentence in this case:). If I were in your place,
> > I would think about it similarly.
> > 
> > I understand these concerns about calling syscalls from the KVM code, and this
> > is why I hide this feature under a separate capability that can be enabled
> > explicitly.
> > 
> > We can think about restricting the list of system calls that this hypercall can
> > execute. In the user-space changes for gVisor, we have a list of system calls
> > that are not executed via this hypercall.
> 
> Can you provide that list?

Here is the list that are not executed via this hypercall:
clone, exit, exit_group, ioctl, rt_sigreturn, mmap, arch_prctl,
sigprocmask.

And here is the list of all system calls that we allow for the Sentry:
clock_gettime, close, dup, dup3, epoll_create1, epoll_ctl, epoll_pwait,
eventfd2, exit, exit_group, fallocate, fchmod, fcntl, fstat, fsync,
ftruncate, futex, getcpu, getpid, getrandom, getsockopt, gettid,
gettimeofday, ioctl, lseek, madvise, membarrier, mincore, mmap,
mprotect, munmap, nanosleep, ppol, pread64, preadv, preadv2, pwrite64,
pwritev, pwritev2, read, recvmsg, recvmmsg, sendmsg, sendmmsg,
restart_syscall, rt_sigaction, rt_sigprocmask, rt_sigreturn,
sched_yield, settimer, shutdown, sigaltstack, statx, sync_file_range,
tee, timer_create, timer_delete, timer_settime, tgkill, utimensat,
write, writev.

> 
> > But it has downsides:
> > * Each sentry system call trigger the full exit to hr3.
> > * Each vmenter/vmexit requires to trigger a signal but it is expensive.
> 
> Can you explain this one?  I didn't quite follow what this is referring to.

In my message, there was the explanation of how the gVisor KVM platform
works right now, and here are two points why it is slow.

Each time when the Sentry triggers a system call, it has to switch to
the host ring3.


When the Sentry wants to switch to the guest ring0, it triggers a signal to
fall in a signal handler. There, we have a sigcontext that we use to get
the current thread state to resume execution in gr0, and then when the
Sentry needs to switch back to hr3, we set the sentry state from gr0 to
sigcontext and returns from the signal handler.

> 
> > * It doesn't allow to support Confidential Computing (SEV-ES/SGX). The Sentry
> >   has to be fully enclosed in a VM to be able to support these technologies.
> 
> Speaking of SGX, this reminds me a lot of Graphene, SCONEs, etc..., which IIRC
> tackled the "syscalls are crazy expensive" problem by using a message queue and
> a dedicated task outside of the enclave to handle syscalls.  Would something like
> that work, or is having to burn a pCPU (or more) to handle syscalls in the host a
> non-starter?

Context-switching is expensive... There was a few attempts to implement
synchronous context-switching ([1], [2]) that can help in this case,
but even with this sort of optimizations, it is too expensive.

1. https://lwn.net/Articles/824409/
2. https://www.spinics.net/lists/linux-api/msg50417.html

Thanks,
Andrei
