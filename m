Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DF2587E58
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 16:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbiHBOrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 10:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbiHBOrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 10:47:13 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933051F2FB
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 07:47:10 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id t1so22271492lft.8
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sTUnnkEh4NNYaXKOrpgiX4GocnwHMt13gQIUfZPwT5Q=;
        b=XVHmeFYHUbieZS2wrbrZqk04cu4LCv8SG7DF2kaGzB1SWJ32c8gevXmNe9xqZglLn1
         cJWzXbyni5EPpuMpGH3AU1O7WnYvQkzsbXuUqecRj47r5KPmbVz/JVJ6HNxnCVyZoUhG
         3e/TlfR1SNnk8ddzRl+nXGOt0CPbDjeotLGHQlG1doSqx6RqlmNfsnY97hUcu3IVgha5
         LaE/z73yq0MUrjGuswBnlh8ZiOmT6qNgXMqu6EFLx5pCWXW7RkNaH3OraUWRPIyryWbe
         3ide4rBv4ovrEg6EP0pe71sO3TWU10/3eobcFnF59FPIp8VFf6PtejKoSYLAnsb63Tp1
         1BXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTUnnkEh4NNYaXKOrpgiX4GocnwHMt13gQIUfZPwT5Q=;
        b=NVtU4DvGqEOTPZT/FU5h2y7N82NP+3eupbX1CCm6rl8hL4l5OrZHmo/EEolwgiizlo
         r7mfEZxTclhlPhkJolFsIhSjvKfarJbSGriDzOExvHGFcvx/Gmuzy6a6iKMQu1APA0eq
         XY2aEelYPDyyBG2yLxxvZ0zV0Zgt9cqi06P9bHnGP5OUbCzRIQ81VfFgr3V/QWBQ407c
         QHzpTvqvYm7CQ9dGZCKQrXsWco4HO0odiLQuc0aW0wYvFarpob0Nq5DzVElhExYOq198
         THQD7pnqOY3hB63nl1FVgCsyepRSz02Cq9VDes6wk/hjnWF3Y8B6uD1mLvrZmQuk8Wzl
         JKpw==
X-Gm-Message-State: AJIora99S1UDOl9Ev/gDG77W8NHYjVK9gh+QH5OKb7NyQw9mxM+Dm54P
        KDxlbqwwKhW14pgAA3YPxpDoUm7PbrN6u5SQzTRtwg==
X-Google-Smtp-Source: AGRyM1ujOsv60zFk5C2kFsDffVdWhAxt1WaPDA4jhOgW9ZQumeIJ7JyANGSZtvcUz44wGhEEfQ7HaSNV4el+EBXK7ZE=
X-Received: by 2002:a05:6512:21a7:b0:48a:a06e:1d21 with SMTP id
 c7-20020a05651221a700b0048aa06e1d21mr7435055lft.494.1659451627302; Tue, 02
 Aug 2022 07:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220801201109.825284-1-pgonda@google.com> <20220801201109.825284-8-pgonda@google.com>
 <20220802095437.fbho3bwgs3yi3fur@kamzik>
In-Reply-To: <20220802095437.fbho3bwgs3yi3fur@kamzik>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 2 Aug 2022 08:46:55 -0600
Message-ID: <CAMkAt6qTBHhVhKBO3g6NR9=wiiE03Na3WrHiUzMo2G8-qY8JOQ@mail.gmail.com>
Subject: Re: [V2 07/11] KVM: selftests: Consolidate boilerplate code in get_ucall()
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Aug 2, 2022 at 3:54 AM Andrew Jones <andrew.jones@linux.dev> wrote:
>
> On Mon, Aug 01, 2022 at 01:11:05PM -0700, Peter Gonda wrote:
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Consolidate the actual copying of a ucall struct from guest=>host into
> > the common get_ucall().  Return a host virtual address instead of a guest
> > virtual address even though the addr_gva2hva() part could be moved to
> > get_ucall() too.  Conceptually, get_ucall() is invoked from the host and
> > should return a host virtual address (and returning NULL for "nothing to
> > see here" is far superior to returning 0).
>
> The code does not match this description anymore, now that
> ucall_arch_get_ucall() returns a gva (as a uint64_t), but the description
> is good, the code is wrong. Please restore the spirit of Sean's patch
> (particularly because it still says it's from Sean...)

As discussed in the encrypted ucall patch I'll get this fixed up to
return gva from ucall_arch_get_ucall() and return a vm_addr_t.

>
> Thanks,
> drew
>
> >
> > Use pointer shenanigans instead of an unnecessary bounce buffer when the
> > caller of get_ucall() provides a valid pointer.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > ---
> >  .../selftests/kvm/include/ucall_common.h      |  8 ++------
> >  .../testing/selftests/kvm/lib/aarch64/ucall.c | 13 +++----------
> >  tools/testing/selftests/kvm/lib/riscv/ucall.c | 19 +++----------------
> >  tools/testing/selftests/kvm/lib/s390x/ucall.c | 16 +++-------------
> >  .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
> >  .../testing/selftests/kvm/lib/x86_64/ucall.c  | 16 +++-------------
> >  6 files changed, 33 insertions(+), 58 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> > index 5a85f5318bbe..c1bc8e33ef3f 100644
> > --- a/tools/testing/selftests/kvm/include/ucall_common.h
> > +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> > @@ -27,9 +27,10 @@ struct ucall {
> >  void ucall_arch_init(struct kvm_vm *vm, void *arg);
> >  void ucall_arch_uninit(struct kvm_vm *vm);
> >  void ucall_arch_do_ucall(vm_vaddr_t uc);
> > -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> > +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
> >
> >  void ucall(uint64_t cmd, int nargs, ...);
> > +uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> >
> >  static inline void ucall_init(struct kvm_vm *vm, void *arg)
> >  {
> > @@ -41,11 +42,6 @@ static inline void ucall_uninit(struct kvm_vm *vm)
> >       ucall_arch_uninit(vm);
> >  }
> >
> > -static inline uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> > -{
> > -     return ucall_arch_get_ucall(vcpu, uc);
> > -}
> > -
> >  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)       \
> >                               ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> >  #define GUEST_SYNC(stage)    ucall(UCALL_SYNC, 2, "hello", stage)
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > index 1c81a6a5c1f2..d2f099caa9ab 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> > @@ -78,24 +78,17 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
> >  uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> >  {
> >       struct kvm_run *run = vcpu->run;
> > -     struct ucall ucall = {};
> > -
> > -     if (uc)
> > -             memset(uc, 0, sizeof(*uc));
> >
> >       if (run->exit_reason == KVM_EXIT_MMIO &&
> >           run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
> > -             vm_vaddr_t gva;
> > +             uint64_t ucall_addr;
> >
> >               TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
> >                           "Unexpected ucall exit mmio address access");
> >               memcpy(&gva, run->mmio.data, sizeof(gva));
> > -             memcpy(&ucall, addr_gva2hva(vcpu->vm, gva), sizeof(ucall));
> >
> > -             vcpu_run_complete_io(vcpu);
> > -             if (uc)
> > -                     memcpy(uc, &ucall, sizeof(ucall));
> > +             return ucall_addr;
> >       }
> >
> > -     return ucall.cmd;
> > +     return 0;
> >  }
> > diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> > index b1598f418c1f..3f000d0b705f 100644
> > --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> > +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> > @@ -51,27 +51,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
> >                 uc, 0, 0, 0, 0, 0);
> >  }
> >
> > -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> > +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_run *run = vcpu->run;
> > -     struct ucall ucall = {};
> > -
> > -     if (uc)
> > -             memset(uc, 0, sizeof(*uc));
> >
> >       if (run->exit_reason == KVM_EXIT_RISCV_SBI &&
> >           run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
> >               switch (run->riscv_sbi.function_id) {
> >               case KVM_RISCV_SELFTESTS_SBI_UCALL:
> > -                     memcpy(&ucall,
> > -                            addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]),
> > -                            sizeof(ucall));
> > -
> > -                     vcpu_run_complete_io(vcpu);
> > -                     if (uc)
> > -                             memcpy(uc, &ucall, sizeof(ucall));
> > -
> > -                     break;
> > +                     return vcpu->vm, run->riscv_sbi.args[0];
> >               case KVM_RISCV_SELFTESTS_SBI_UNEXP:
> >                       vcpu_dump(stderr, vcpu, 2);
> >                       TEST_ASSERT(0, "Unexpected trap taken by guest");
> > @@ -80,6 +68,5 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> >                       break;
> >               }
> >       }
> > -
> > -     return ucall.cmd;
> > +     return 0;
> >  }
> > diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> > index 114cb4af295f..f7a5a7eb4aa8 100644
> > --- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
> > +++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> > @@ -20,13 +20,9 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
> >       asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
> >  }
> >
> > -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> > +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_run *run = vcpu->run;
> > -     struct ucall ucall = {};
> > -
> > -     if (uc)
> > -             memset(uc, 0, sizeof(*uc));
> >
> >       if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
> >           run->s390_sieic.icptcode == 4 &&
> > @@ -34,13 +30,7 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> >           (run->s390_sieic.ipb >> 16) == 0x501) {
> >               int reg = run->s390_sieic.ipa & 0xf;
> >
> > -             memcpy(&ucall, addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]),
> > -                    sizeof(ucall));
> > -
> > -             vcpu_run_complete_io(vcpu);
> > -             if (uc)
> > -                     memcpy(uc, &ucall, sizeof(ucall));
> > +             return run->s.regs.gprs[reg];
> >       }
> > -
> > -     return ucall.cmd;
> > +     return 0;
> >  }
> > diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> > index 749ffdf23855..a060252bab40 100644
> > --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> > +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> > @@ -18,3 +18,22 @@ void ucall(uint64_t cmd, int nargs, ...)
> >
> >       ucall_arch_do_ucall((vm_vaddr_t)&uc);
> >  }
> > +
> > +uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> > +{
> > +     struct ucall ucall;
> > +     void *addr;
> > +
> > +     if (!uc)
> > +             uc = &ucall;
> > +
> > +     addr = addr_gva2hva(vcpu->vm, ucall_arch_get_ucall(vcpu));
> > +     if (addr) {
> > +             memcpy(uc, addr, sizeof(*uc));
> > +             vcpu_run_complete_io(vcpu);
> > +     } else {
> > +             memset(uc, 0, sizeof(*uc));
> > +     }
> > +
> > +     return uc->cmd;
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > index 9f532dba1003..24746120a593 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > @@ -22,25 +22,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
> >               : : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
> >  }
> >
> > -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> > +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_run *run = vcpu->run;
> > -     struct ucall ucall = {};
> > -
> > -     if (uc)
> > -             memset(uc, 0, sizeof(*uc));
> >
> >       if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
> >               struct kvm_regs regs;
> >
> >               vcpu_regs_get(vcpu, &regs);
> > -             memcpy(&ucall, addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi),
> > -                    sizeof(ucall));
> > -
> > -             vcpu_run_complete_io(vcpu);
> > -             if (uc)
> > -                     memcpy(uc, &ucall, sizeof(ucall));
> > +             return regs.rdi;
> >       }
> > -
> > -     return ucall.cmd;
> > +     return 0;
> >  }
> > --
> > 2.37.1.455.g008518b4e5-goog
> >
