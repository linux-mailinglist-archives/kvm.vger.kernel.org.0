Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A5957EA1C
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbiGVXCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiGVXCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:02:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4816A7B366
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d10-20020a170902ceca00b0016bea2dc145so3303570plg.7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Gvp/73vL/wYhHUzfrA+ck8Wczuy8shTz34sZSNOpQKg=;
        b=WK6X/HCymmMhe2Mzd8y2j/58pke48wRYsfxle5do6yBeImKUe6NkD1aWKlMeNUj7eb
         qWztqrOhJgl7pnatCMNFALGK7dHBwY/h1nASnlRM/fe17TSspBkw8QWN6tyDjBfmhCEu
         d1hJ+CtoqxFPFmfNWnORIJGDtSd6Xo05giuWFq9l1DhKZTAqBT1rg0E1B73qi7KXyJ9I
         rSc1QxV0JZG5O451pH8VmHxqvTP1mq9dr+Uyk69Hkff9G8OlSF0zf526obnMe2njXfcl
         Rt1LZtwQ3yB3eyJEnJdjo2cgxlh4NX7kOYQ/AHxHFd7/64TiVjCWK/jGeI/rHGb1to1S
         tOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Gvp/73vL/wYhHUzfrA+ck8Wczuy8shTz34sZSNOpQKg=;
        b=xJxpXKc2vmqwW+brElI8s/MGATWqp2i5nlkumyYV7Ae0vjGiz3iTRdY8JD5tf0B+oY
         3tMg15m3a3DHVjHUwOKUcBLwH6TyoeSejNeCFgIHaD0Kqe4aippKgoqkaF51weyPYD9L
         vWqSxy6NEpQOB1Bbhpbrx1UKHeMmJe43msly96exp7ISzyvKCvdLzbe+cJ2CXHFOT9Wr
         TUoLXRicjTB/7rfhvLxIvNWxakpiWYTrwnr6JF8ljziBM5XM/qkAYp8VIYAm49Dd7AN4
         pay63VmvTo2SsbPnek2XBZl0d5ORg6BPSRH1Cowq8yP6DvWklczTFjCW4e+G9q5u7aSf
         aciA==
X-Gm-Message-State: AJIora/P75gd2KVo/TDeKbfb56LqxV0bSipGuVgSsIUv5tF4BPlk/Tau
        BSPEbBTD5xhO/4/v1HozHcY2eSzfksY=
X-Google-Smtp-Source: AGRyM1tBuelDgbLuw8EGH0svy/Xr5MelYsBuu3cp1RWIhrClKaHTLWQWU8s8jF0YKIuNJ/zuupLH1FGBQsQ=
X-Received: from avagin.kir.corp.google.com ([2620:15c:29:204:5863:d08b:b2f8:4a3e])
 (user=avagin job=sendgmr) by 2002:aa7:9e9b:0:b0:528:2948:e974 with SMTP id
 p27-20020aa79e9b000000b005282948e974mr1941123pfq.79.1658530964856; Fri, 22
 Jul 2022 16:02:44 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:02:36 -0700
Message-Id: <20220722230241.1944655-1-avagin@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
From:   Andrei Vagin <avagin@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrei Vagin <avagin@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a class of applications that use KVM to manage multiple address
spaces rather than use it as an isolation boundary. In all other terms,
they are normal processes that execute system calls, handle signals,
etc. Currently, each time when such a process needs to interact with the
operation system, it has to switch to host and back to guest. Such
entire switches are expensive and significantly increase the overhead of
system calls. The new hypercall reduces this overhead by more than two
times.

The new hypercall runs system calls on the host.  As for native system
calls, seccomp filters are executed before system calls. It takes one
argument that is a pointer to a pt_regs structure in the host address
space. It provides registers to execute a system call according to the
calling convention. Arguments are passed in %rdi, %rsi, %rdx, %r10, %r8
and %r9 and a return code is stored in %rax.=C2=A0

The hypercall returns 0 if a system call has been executed. Otherwise,
it returns an error code.

This series introduces a new capability that has to be set to enable the
hypercall. The new hypercall is a backdoor for regular virtual machines,
so it is disabled by default. There is another standard way to allow
hypercalls via cpuid. It has not been used because one of the common
ways to manage them is to request all available features and let them
all together. In this case, it is a hard requirement that the new
hypercall can be enabled only intentionally.

=3D Background =3D

gVisor is one such application. It is an application kernel written in
Go that implements a substantial portion of the Linux system call
interface. gVisor intercepts application system calls and acts as the
guest kernel. It has a platform abstraction that implements interception
of syscalls, basic context switching, and memory mapping functionality.
Currently, it has two platforms: ptrace and KVM.

The ptrace platform uses PTRACE_SYSEMU to execute user code without
allowing it to perform host system calls, and it creates stub processes
to manage user address spaces. This platform is primarily for testing
needs due to its bad performance.

Another option is the KVM platform. In this case, the Sentry (gVisor
kernel) can run in a guest ring0 and create/manage multiple address
spaces. Its performance is much better than the ptrace one, but it is
still not great compared with the native performance. This change
optimizes the most critical part, which is the syscall overhead.  The
idea of using vmcall to execute system calls isn=E2=80=99t new. Two large u=
sers
of gVisor (Google and AntFinacial) have out-of-tree code to implement
such hypercalls.

In the Google kernel, we have a kvm-like subsystem designed especially
for gVisor. This change is the first step of integrating it into the KVM
code base and making it available to all Linux users.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jianfeng Tan <henry.tjf@antfin.com>
Cc: Adin Scannell <ascannell@google.com>
Cc: Konstantin Bogomolov <bogomolov@google.com>
Cc: Etienne Perot <eperot@google.com>

Andrei Vagin (5):
  kernel: add a new helper to execute system calls from kernel code
  kvm: add controls to enable/disable paravirtualized system calls
  KVM/x86: add a new hypercall to execute host system calls.
  selftests/kvm/x86_64: set rax before vmcall
  selftests/kvm/x86_64: add tests for KVM_HC_HOST_SYSCALL

 Documentation/virt/kvm/x86/hypercalls.rst     |  15 ++
 arch/x86/entry/common.c                       |  48 ++++++
 arch/x86/include/asm/syscall.h                |   1 +
 arch/x86/include/uapi/asm/kvm_para.h          |   2 +
 arch/x86/kvm/cpuid.c                          |  25 +++
 arch/x86/kvm/cpuid.h                          |   8 +-
 arch/x86/kvm/x86.c                            |  37 +++++
 include/uapi/linux/kvm.h                      |   1 +
 include/uapi/linux/kvm_para.h                 |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   4 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
 .../kvm/x86_64/kvm_pv_syscall_test.c          | 145 ++++++++++++++++++
 14 files changed, 289 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_pv_syscall_test.=
c

--=20
2.37.0.rc0.161.g10f37bed90-goog

