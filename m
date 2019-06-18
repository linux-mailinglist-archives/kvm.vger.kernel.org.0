Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034414A8FD
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 20:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfFRSBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 14:01:20 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:35782 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRSBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 14:01:20 -0400
Received: by mail-io1-f43.google.com with SMTP id m24so32024781ioo.2
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 11:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KsDouzPFp6mn7LO3U3xkjdfRK30ihjPy8NA62BQlChM=;
        b=qdR0gvvfZg+uNzUl1C59YofPBiBmX8KBT402tg+Zmmv6ksZKQLPHC46EWBUPe8fEJi
         jy+LriaXQpug3LBfF9vRsAuT2lyK8R0Sq2OO1dJd47lZRQLwXxk0gaCEFnplXNv+c0ut
         b6qnQp38TcRfWX+ABLrk/P1n2MHNOZH+3NkD1Lic+/EUL5XEp3wBn9/4XYcm75YhvVcb
         4jVcaQ6NB0B5cv3eQd9x6SBAsYqTwTea8CmII6BBO5c0dRzTqKURrHrgIVMJOGwIP45h
         RKeojTgN43OWa9/XefvSA7KZXsduk83R5cUFnoo9rARznHUKzv2Jh098ObGYv8sOSjNi
         Q7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KsDouzPFp6mn7LO3U3xkjdfRK30ihjPy8NA62BQlChM=;
        b=aGRuLWspsslqiHojBKFyHybjH/z/+mLfY2ZH9W4B94jZ4DZqmeRNwBI5yPokEcZyNl
         Ze9RNDrk/3xFPhG34Rov726Bz/GALDT1uxGphF5xAW9JRk1oHq0up9pJtC59LiJY7bmH
         B3nTju1o8GWDkhcWP9rF6zm1HAe7QrSqD5q9fdnULmRMr/IXNq/jD/dnjmMYY1qMJbhP
         qOYCtlo0vkEMHVf0dnmTnjeanvQ7GuMPG4mN/LGC4pRqpgvt+RJQAB4/yekqt+548kSF
         xw42jq9qV0nVIMEPYuitcw8Rf7xo3tQE6TwZPPk3rWMPgogfz2jC+47SCWUrua4cO5sL
         TFKg==
X-Gm-Message-State: APjAAAUPimUotDUziQ4SlzKOYoRNgNZgsU+ej99ccsGy5wkdiq1OvMNB
        43Vx02/g5lT6jvv0kof+idNTEumju2f0nJaq1J05Rw==
X-Google-Smtp-Source: APXvYqwXyVhcy3ca1Y3ZdS7S8JglyZsEd+4blkzOaylfnnx7xoHUv9SM5hd29O6Q36p99XFsWwF2XTiWEqnZuRvx8pw=
X-Received: by 2002:a5e:c241:: with SMTP id w1mr8088615iop.58.1560880879243;
 Tue, 18 Jun 2019 11:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
 <20190612161255.GN32652@zn.tnic> <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
 <20190612195152.GQ32652@zn.tnic> <20190612205430.GA26320@linux.intel.com>
 <20190613071805.GA11598@zn.tnic> <df80299b-8e1f-f48b-a26b-c163b4018d01@oracle.com>
 <20190618175153.GC26346@zn.tnic>
In-Reply-To: <20190618175153.GC26346@zn.tnic>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 18 Jun 2019 20:01:06 +0200
Message-ID: <CACT4Y+bnKwniAikESjDckaTW=vE1hu8yc4DuoSFwP3qTS4NpmA@mail.gmail.com>
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
To:     Borislav Petkov <bp@alien8.de>
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, KVM list <kvm@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 18, 2019 at 7:52 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Mon, Jun 17, 2019 at 11:13:22AM -0400, George Kennedy wrote:
> >    319f3:       0f 01 da                vmload                       <--- svm_vcpu_run+0xa83
>
> Hmm, so VMLOAD can fault for a bunch of reasons if you look at its
> description in the APM.
>
> Looking at your Code: section and building with your config, rIP and the
> insns around it point to:
>
> All code
> ========
>    0:   00 55 89                add    %dl,-0x77(%rbp)
>    3:   d2 45 89                rolb   %cl,-0x77(%rbp)
>    6:   c9                      leaveq
>    7:   48 89 e5                mov    %rsp,%rbp
>    a:   8b 45 18                mov    0x18(%rbp),%eax
>    d:   50                      push   %rax
>    e:   8b 45 10                mov    0x10(%rbp),%eax
>   11:   50                      push   %rax
>   12:   e8 8a 42 6b 00          callq  0x6b42a1
>   17:   58                      pop    %rax
>   18:   5a                      pop    %rdx
>   19:   c9                      leaveq
>   1a:   c3                      retq
>   1b:   66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
>   21:   66 66 66 66 90          data16 data16 data16 xchg %ax,%ax
>   26:   55                      push   %rbp
>   27:   48 89 e5                mov    %rsp,%rbp
>   2a:*  0f 0b                   ud2             <-- trapping instruction
>   2c:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>   31:   66 66 66 66 90          data16 data16 data16 xchg %ax,%ax
>   36:   55                      push   %rbp
>   37:   48 89 e5                mov    %rsp,%rbp
>   3a:   41 55                   push   %r13
>   3c:   41 54                   push   %r12
>   3e:   41                      rex.B
>   3f:   89                      .byte 0x89
>
> 0000000000017f30 <__bpf_trace_kvm_nested_vmexit>:
>    17f30:       55                      push   %rbp
>    17f31:       89 d2                   mov    %edx,%edx
>    17f33:       45 89 c9                mov    %r9d,%r9d
>    17f36:       48 89 e5                mov    %rsp,%rbp
>    17f39:       8b 45 18                mov    0x18(%rbp),%eax
>    17f3c:       50                      push   %rax
>    17f3d:       8b 45 10                mov    0x10(%rbp),%eax
>    17f40:       50                      push   %rax
>    17f41:       e8 00 00 00 00          callq  17f46 <__bpf_trace_kvm_nested_vmexit+0x16>
>    17f46:       58                      pop    %rax
>    17f47:       5a                      pop    %rdx
>    17f48:       c9                      leaveq
>    17f49:       c3                      retq
>    17f4a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
>
> 0000000000017f50 <kvm_spurious_fault>:
>    17f50:       e8 00 00 00 00          callq  17f55 <kvm_spurious_fault+0x5>
>    17f55:       55                      push   %rbp
>    17f56:       48 89 e5                mov    %rsp,%rbp
>    17f59:       0f 0b                   ud2
>    17f5b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>
> so the invalid opcode splat is dumping the insn bytes around rIP the
> UD2 happens but in order to see which of the VMLOAD conditions causes
> the fault, you'd probably need to intercept the fault handler and dump
> registers in the hypervisor to check.
>
> There's something else that's bothering me though: your splat is from
> the guest yet there is svm_vcpu_run() mentioned there which should be
> called by the hypervisor and not by the guest. Unless you're doing
> nested virt stuff...
>
> Anyway, sorry that I cannot be of more help - I'm sure KVM guys would
> make much more sense of it.

I am not a KVM folk either, but FWIW syzkaller is capable of creating
a double-nested VM. The code is somewhat VMX-specific, but it should
be capable at least executing some SVM instructions inside of guest.
This code setups VM to run a given instruction sequences (should be generic):
https://github.com/google/syzkaller/blob/34bf9440bd06034f86b5d9ac8afbf078129cbdae/executor/common_kvm_amd64.h
The instruction generator is based on Intel XED so it may be somewhat
Intel-biased, but at least I see some mentions of SVM there:
https://raw.githubusercontent.com/google/syzkaller/34bf9440bd06034f86b5d9ac8afbf078129cbdae/pkg/ifuzz/gen/all-enc-instructions.txt
And this code can setup a double-nested VM, but it's VMX-specific:
https://github.com/google/syzkaller/blob/34bf9440bd06034f86b5d9ac8afbf078129cbdae/executor/kvm.S#L125

If there is specific interested in testing SVM, it can make sense to
improve SVM support in syzkaller to at least match VMX.
