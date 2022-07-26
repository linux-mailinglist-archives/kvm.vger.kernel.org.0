Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55922580F17
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 10:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbiGZIdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 04:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiGZIdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 04:33:40 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE7D2F3A8
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:33:39 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-31bf3656517so134581677b3.12
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Zj6IDscOqGpySURIv3/6OT9Yjl3MfpVD47TFHbtsSY=;
        b=Cq3woY32gfETWotKVJ0jVvPaZnuXlO78yPMcYGL8XNfszfNG7vyRsamBeGl50H7/DM
         J4k0t8KmRkm3KkP1t1wOHez6f3tCNBb5ZYCEXlAegZfUA1u1uQ2N4SyDIsmwBF6HImaV
         A7ct2UFqNDuN9o8jqRbLaVguw6IYnuM4PnMqtw756iGGGcOXvtYVuMCLiPtkWFXIR4QD
         i/9LXg2E5q5LxtRVbWiRFKxQBEWsHFGOIs0KmhqhLaPeYWCS/OBQdZA/foxm0yZypBzP
         AUjJqyGrt6YMi7GLRGTUEaTJF7FrAPzyZL37KFUUJjNFMtJ00jt0BgkhbdosUZK2Kvaw
         QH+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Zj6IDscOqGpySURIv3/6OT9Yjl3MfpVD47TFHbtsSY=;
        b=ya91uj7CF7X0ciADGENBj27l6hdQSbjQiF7UkE/v8HrJwbWnEsPVsou3W+UCFeDhXz
         md2w7WrfiYvx8mXUHlqxPDdg6OyF6XmYq3GsnTXmsZIPUwgb7nFHsl22JXElIxOdDiBr
         P+gVbRvHr1A1CjaMupLzFwnBO9Q44fEY7QCeRNHCqVK0IcjCa9SQUUqWpg4ZJt3lAyqU
         7WqfiUknDqrSMh7xzYOD3ldzefts5/mikX4MTUacPLWGNFV4+krgaWIXUXLh+08Fldch
         IyA6LHZ91nC+pWeW/xXU8xgO6kfqSfKsE1XRw8vGXG/uugDIaEN+AffjlRUXUg1+U+P2
         5K3w==
X-Gm-Message-State: AJIora/asBgjQX3gsnxNjHHn4q7Ctvsuv4ShBSsxHurkf+DRvaiqNCgi
        3d9tNZ9CcrxqY782yOl1yP/Xg1gOsET1epyB7ylnxQ==
X-Google-Smtp-Source: AGRyM1ua9TSRpV0zIZSYIP6XnTuBYQmdJo06utwGMAgbUoepW/SG6vP4DyIAXqYyoa7tAeOpas2aiWwwh7IAFnd+Z+I=
X-Received: by 2002:a81:74d:0:b0:31e:c419:fc75 with SMTP id
 74-20020a81074d000000b0031ec419fc75mr13398395ywh.364.1658824418308; Tue, 26
 Jul 2022 01:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220722230241.1944655-1-avagin@google.com> <Yts1tUfPxdPH5XGs@google.com>
In-Reply-To: <Yts1tUfPxdPH5XGs@google.com>
From:   Andrei Vagin <avagin@google.com>
Date:   Tue, 26 Jul 2022 01:33:27 -0700
Message-ID: <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022 at 4:41 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> +x86 maintainers, patch 1 most definitely needs acceptance from folks bey=
ond KVM.
>
> On Fri, Jul 22, 2022, Andrei Vagin wrote:
> > Another option is the KVM platform. In this case, the Sentry (gVisor
> > kernel) can run in a guest ring0 and create/manage multiple address
> > spaces. Its performance is much better than the ptrace one, but it is
> > still not great compared with the native performance. This change
> > optimizes the most critical part, which is the syscall overhead.
>
> What exactly is the source of the syscall overhead,

Here are perf traces for two cases: when "guest" syscalls are executed via
hypercalls and when syscalls are executed by the user-space VMM:
https://gist.github.com/avagin/f50a6d569440c9ae382281448c187f4e

And here are two tests that I use to collect these traces:
https://github.com/avagin/linux-task-diag/commit/4e19c7007bec6a15645025c337=
f2e85689b81f99

If we compare these traces, we can find that in the second case, we spend e=
xtra
time in vmx_prepare_switch_to_guest, fpu_swap_kvm_fpstate, vcpu_put,
syscall_exit_to_user_mode.

> and what alternatives have been explored?  Making arbitrary syscalls from
> within KVM is mildly terrifying.

"mildly terrifying" is a good sentence in this case:). If I were in your pl=
ace,
I would think about it similarly.

I understand these concerns about calling syscalls from the KVM code, and t=
his
is why I hide this feature under a separate capability that can be enabled
explicitly.

We can think about restricting the list of system calls that this hypercall=
 can
execute. In the user-space changes for gVisor, we have a list of system cal=
ls
that are not executed via this hypercall. For example, sigprocmask is never
executed by this hypercall, because the kvm vcpu has its signal mask.  Anot=
her
example is the ioctl syscall, because it can be one of kvm ioctl-s.

As for alternatives, we explored different ways:

=3D=3D Host Ring3/Guest ring0 mixed mode =3D=3D

This is how the gVisor KVM platform works right now. We don=E2=80=99t have =
a separate
hypervisor, and the Sentry does its functions. The Sentry creates a KVM vir=
tual
machine instance, sets it up, and handles VMEXITs. As a result, the Sentry =
runs
in the host ring3 and the guest ring0 and can transparently switch between
these two contexts.

When the Sentry starts, it creates a new kernel VM instance and maps its me=
mory
to the guest physical. Then it makes a set of page tables for the Sentry th=
at
mirrors the host virtual address space. When host and guest address spaces =
are
identical, the Sentry can switch between these two contexts.

The bluepill function switches the Sentry into guest ring0. It calls a
privileged instruction (CLI) that is a no-op in the guest (by design, since=
 we
ensure interrupts are disabled for guest ring 0 execution) and triggers a
signal on the host. The signal is handled by the bluepillHandler that takes=
 a
virtual CPU and executes it with the current thread state grabbed from a si=
gnal
frame.

As for regular VMs, user processes have their own address spaces (page tabl=
es)
and run in guest ring3. So when the Sentry is going to execute a user proce=
ss,
it needs to be sure that it is running inside a VM, and it is the exact poi=
nt
when it calls bluepill(). Then it executes a user process with its page tab=
les
before it triggers an exception or a system call. All such events are trapp=
ed
and handled in the Sentry.

The Sentry is a normal Linux process that can trigger a fault and execute
system calls. To handle these events, the Sentry returns to the host mode. =
If
ring0 sysenter or exception entry point detects an event from the Sentry, t=
hey
save the current thread state on a per-CPU structure and trigger VMEXIT. Th=
is
returns us into bluepillHandler, where we set the thread state on a signal
frame and exit from the signal handler, so the Sentry resumes from the poin=
t
where it has been in the VM.

In this scheme, the sentry syscall time is 3600ns. This is for the case whe=
n a
system call is called from gr0.

The benefit of this way is that only a first system call triggers vmexit an=
d
all subsequent syscalls are executed on the host natively.

But it has downsides:
* Each sentry system call trigger the full exit to hr3.
* Each vmenter/vmexit requires to trigger a signal but it is expensive.
* It doesn't allow to support Confidential Computing (SEV-ES/SGX). The Sent=
ry
  has to be fully enclosed in a VM to be able to support these technologies=
.

=3D=3D Execute system calls from a user-space VMM =3D=3D

In this case, the Sentry is always running in VM, and a syscall handler in =
GR0
triggers vmexit to transfer control to VMM (user process that is running in
hr3), VMM executes a required system call, and transfers control back to th=
e
Sentry. We can say that it implements the suggested hypercall in the
user-space.

The sentry syscall time is 2100ns in this case.

The new hypercall does the same but without switching to the host ring 3. I=
t
reduces the sentry syscall time to 1000ns.


=3D=3D A new BPF hook to handle vmexit-s  =3D=3D

https://github.com/avagin/linux-task-diag/commits/kvm-bpf

This way allows us to reach the same performance numbers, but it gives less
control over who and how use this functionality. Second, it requires adding=
 a
few questionable BPF helpers like calling syscall from BPF hooks.

=3D=3D Non-KVM platforms =3D=3D

We are experimenting with non-KVM platforms. We have the ptrace platform, b=
ut it
is almost for experiments due to the slowness of the ptrace interface.

Another idea was to add the process_vm_exec system call:
https://lwn.net/Articles/852662/

This system call can significantly increase performance compared with the
ptrace platform, but it is still slower than the KVM platform in its curren=
t
form (without the new hypercall). But this is true only if we run the KVM
platform on a bare-metal. In the case of nested-virtualization, the KVM
platform becomes much slower, which is expected.

We have another idea to use the seccomp notify to trap system calls, but it
requires some kernel change to reach a reasonable performance. I am working=
 on
these changes and will present them soon.

I want to emphasize that non-KVM platforms don't allow us to implement the
confidential concept in gVisor, but this is one of our main goals concernin=
g
the KVM platform.

All previous numbers have been getting from the same host (Xeon(R) Gold 626=
8CL,
5.19-rc5).

>
> > The idea of using vmcall to execute system calls isn=E2=80=99t new. Two=
 large users
> > of gVisor (Google and AntFinacial) have out-of-tree code to implement s=
uch
> > hypercalls.
> >
> > In the Google kernel, we have a kvm-like subsystem designed especially
> > for gVisor. This change is the first step of integrating it into the KV=
M
> > code base and making it available to all Linux users.
>
> Can you please lay out the complete set of changes that you will be propo=
sing?
> Doesn't have to be gory details, but at a minimum there needs to be a hig=
h level
> description that very clearly defines the scope of what changes you want =
to make
> and what the end result will look like.
>
> It's practically impossible to review this series without first understan=
ding the
> bigger picture, e.g. if KVM_HC_HOST_SYSCALL is ultimately useless without=
 the other
> bits you plan to upstream, then merging it without a high level of confid=
ence that
> the other bits are acceptable is a bad idea since it commits KVM to suppo=
rting
> unused ABI.

I was not precise in my description. This is the only change that we
need right now.
The gVisor KVM platform is the real thing that exists today and works
on the upstream kernels:
https://cs.opensource.google/gvisor/gvisor/+/master:pkg/sentry/platform/kvm=
/

This hypercall improves its performance and makes it comparable with
the google-internal platform.

Thanks,
Andrei
