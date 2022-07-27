Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403395827D7
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 15:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiG0Nir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 09:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbiG0Nip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 09:38:45 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C228331221
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 06:38:43 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id m9so19792827ljp.9
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 06:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=01SxzwTXIr6QmkBXsOzV/x03DGAo7wvc6arostfrER0=;
        b=fTDCoPJg0/1JUl1IPpJqf24GWfjQtpztbl8P+lODPg5PPidK7kpQwQS1wSuBkeaj7z
         U6iPwGqsVmo2/08lxwSJTg14e/3z0o552iQt2sax3QLj3qm1S5PT3MEpqn4o9cMhc1bl
         ludd4tGkjsMwpCWSf90D8lTHCQqaE7kULErHZ5iramvRfeqBNEG128NsnkmP/Zn0RXEh
         Us/sg9PMhfK4qfMPgxobdAeI/IPzZL7+T0KPdFwX/lZwYaPswidXLGuU0Q/Mtt5XZAn4
         7jIdZRFVp/aCPlLsf1hA1+VZXgxGoPjITHzZ9e7d3KMAVlX1/ZeUiXWECXPQ9tZ5wMOo
         F5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=01SxzwTXIr6QmkBXsOzV/x03DGAo7wvc6arostfrER0=;
        b=bF16m41cA7E4pWV0SD+6Da8a3bbAZsG1jm65SF1Eg8C5Tlb6lPoOkCpX/ihtiLEWv0
         EHVRc2Z7UFa+lJgfed8KF7FqaXv/Jy/Fy9Wi7ZBdsdadvmn5UCWowKid1kFA7mTKIlX/
         XrntCYaca8d69DSWB+Kl7ZofdfQojDVckld8cwK4/01BRCwJIsiZFEOoRhbCtTsYdPEi
         INgDbou1RKTxlt6vwJREyzxmQMgZSru6/XBwvlNmtvv0scYk2sHrHfBfmaSekcOX1syu
         iCKS3dLTuJcQMfHDtNHL10jf8BhbaZDvmYNcEYef3gG9u8GcOwV+mx59jDvUj1KYW1/K
         cTxw==
X-Gm-Message-State: AJIora/0OuzPwYyfURbtOr39H22MUXiqtMD/q1Mo4ncldO8y4g7CYwqx
        oDm5N9tUhrg1x8fddn2w5jTIdFM1+3/PzOUpKFIDVw==
X-Google-Smtp-Source: AGRyM1vL8A4J/SSNa74azS/uA9ndVqS4FGelplhMjFsfOb8ckB4fD7NXALZNggyqeQKDcaF3XV75aC25YSXniVerVOA=
X-Received: by 2002:a2e:b88d:0:b0:25e:5aa:749d with SMTP id
 r13-20020a2eb88d000000b0025e05aa749dmr5753390ljp.48.1658929121691; Wed, 27
 Jul 2022 06:38:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com> <20220715192956.1873315-10-pgonda@google.com>
 <20220719154330.wnwnu23gagcya3o7@kamzik>
In-Reply-To: <20220719154330.wnwnu23gagcya3o7@kamzik>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 27 Jul 2022 07:38:29 -0600
Message-ID: <CAMkAt6rFO6J5heuwocmvb_wstOOwsf9WooXu9iEUOvK0wEDAhw@mail.gmail.com>
Subject: Re: [RFC V1 08/10] KVM: selftests: Make ucall work with encrypted guests
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

On Tue, Jul 19, 2022 at 9:43 AM Andrew Jones <andrew.jones@linux.dev> wrote:
>
> On Fri, Jul 15, 2022 at 12:29:54PM -0700, Peter Gonda wrote:
> > Add support for encrypted, SEV, guests in the ucall framework. If
> > encryption is enabled set up a pool of ucall structs in the guests'
> > shared memory region. This was suggested in the thread on "[RFC PATCH
> > 00/10] KVM: selftests: Add support for test-selectable ucall
> > implementations". Using a listed as suggested there doesn't work well
>
> list
>
> > because the list is setup using HVAs not GVAs so use a bitmap + array
> > solution instead to get the same pool result.
> >
> > Suggested-by:Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> >
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/include/kvm_util_base.h     |  30 +++--
> >  .../selftests/kvm/include/ucall_common.h      |  14 +--
> >  .../testing/selftests/kvm/lib/ucall_common.c  | 115 ++++++++++++++++--
> >  .../testing/selftests/kvm/lib/x86_64/ucall.c  |   2 +-
> >  5 files changed, 134 insertions(+), 28 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 61e85892dd9b..3d9f2a017389 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -47,6 +47,7 @@ LIBKVM += lib/rbtree.c
> >  LIBKVM += lib/sparsebit.c
> >  LIBKVM += lib/test_util.c
> >  LIBKVM += lib/ucall_common.c
> > +LIBKVM += $(top_srcdir)/tools/lib/find_bit.c
>
> Why is this file being added?

This is a mistake, I'll revert. I was originally trying to use
find_first_zero_bit().

>
> >
> >  LIBKVM_x86_64 += lib/x86_64/apic.c
> >  LIBKVM_x86_64 += lib/x86_64/handlers.S
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 60b604ac9fa9..77aff2356d64 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -65,6 +65,7 @@ struct userspace_mem_regions {
> >  /* Memory encryption policy/configuration. */
> >  struct vm_memcrypt {
> >       bool enabled;
> > +     bool encrypted;
> >       int8_t enc_by_default;
> >       bool has_enc_bit;
> >       int8_t enc_bit;
> > @@ -99,6 +100,8 @@ struct kvm_vm {
> >       int stats_fd;
> >       struct kvm_stats_header stats_header;
> >       struct kvm_stats_desc *stats_desc;
> > +
> > +     struct list_head ucall_list;
> >  };
> >
> >
> > @@ -141,21 +144,21 @@ enum vm_guest_mode {
> >
> >  extern enum vm_guest_mode vm_mode_default;
> >
> > -#define VM_MODE_DEFAULT                      vm_mode_default
> > -#define MIN_PAGE_SHIFT                       12U
> > -#define ptes_per_page(page_size)     ((page_size) / 8)
> > +#define VM_MODE_DEFAULT            vm_mode_default
> > +#define MIN_PAGE_SHIFT            12U
> > +#define ptes_per_page(page_size)    ((page_size) / 8)
> >
> >  #elif defined(__x86_64__)
> >
> > -#define VM_MODE_DEFAULT                      VM_MODE_PXXV48_4K
> > -#define MIN_PAGE_SHIFT                       12U
> > -#define ptes_per_page(page_size)     ((page_size) / 8)
> > +#define VM_MODE_DEFAULT            VM_MODE_PXXV48_4K
> > +#define MIN_PAGE_SHIFT            12U
> > +#define ptes_per_page(page_size)    ((page_size) / 8)
> >
> >  #elif defined(__s390x__)
> >
> > -#define VM_MODE_DEFAULT                      VM_MODE_P44V64_4K
> > -#define MIN_PAGE_SHIFT                       12U
> > -#define ptes_per_page(page_size)     ((page_size) / 16)
> > +#define VM_MODE_DEFAULT            VM_MODE_P44V64_4K
> > +#define MIN_PAGE_SHIFT            12U
> > +#define ptes_per_page(page_size)    ((page_size) / 16)
> >
> >  #elif defined(__riscv)
> >
> > @@ -163,9 +166,9 @@ extern enum vm_guest_mode vm_mode_default;
> >  #error "RISC-V 32-bit kvm selftests not supported"
> >  #endif
> >
> > -#define VM_MODE_DEFAULT                      VM_MODE_P40V48_4K
> > -#define MIN_PAGE_SHIFT                       12U
> > -#define ptes_per_page(page_size)     ((page_size) / 8)
> > +#define VM_MODE_DEFAULT            VM_MODE_P40V48_4K
> > +#define MIN_PAGE_SHIFT            12U
> > +#define ptes_per_page(page_size)    ((page_size) / 8)
>
> Looks like your editor decided to change all the above defines to use
> spaces instead of tabs. You might want to double check the other
> patches as well to ensure lines added use tabs vs. spaces and that
> there are no other random whitespace changes.

Will fix.

>
> >
> >  #endif
> >
> > @@ -802,6 +805,9 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
> >
> >  static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> >  {
> > +     TEST_ASSERT(
> > +             !vm->memcrypt.encrypted,
> > +             "Encrypted guests have their page tables encrypted so gva2* conversions are not possible.");
> >       return addr_arch_gva2gpa(vm, gva);
> >  }
> >
> > diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> > index cb9b37282701..d8ac16a68c0a 100644
> > --- a/tools/testing/selftests/kvm/include/ucall_common.h
> > +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> > @@ -21,6 +21,10 @@ enum {
> >  struct ucall {
> >       uint64_t cmd;
> >       uint64_t args[UCALL_MAX_ARGS];
> > +
> > +     /* For encrypted guests. */
> > +     uint64_t idx;
> > +     struct ucall *hva;
> >  };
> >
> >  void ucall_arch_init(struct kvm_vm *vm, void *arg);
> > @@ -31,15 +35,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
> >  void ucall(uint64_t cmd, int nargs, ...);
> >  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> >
> > -static inline void ucall_init(struct kvm_vm *vm, void *arg)
> > -{
> > -     ucall_arch_init(vm, arg);
> > -}
> > +void ucall_init(struct kvm_vm *vm, void *arg);
> >
> > -static inline void ucall_uninit(struct kvm_vm *vm)
> > -{
> > -     ucall_arch_uninit(vm);
> > -}
> > +void ucall_uninit(struct kvm_vm *vm);
> >
> >  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)       \
> >                               ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> > diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> > index c488ed23d0dd..8e660b10f9b2 100644
> > --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> > +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> > @@ -1,22 +1,123 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  #include "kvm_util.h"
> > +#include "linux/types.h"
> > +#include "linux/bitmap.h"
> > +#include "linux/bitops.h"
> > +#include "linux/atomic.h"
>
> Do we really need bitmap.h, bitops.h, and atomic.h? I see we use
> clear_bit(), which I think is from atomic.h, and
> atomic_test_and_set_bit(), which I have no idea where it comes from...

I added that function to atomic.h in "RFC V1 07/10] tools: Add
atomic_test_and_set_bit()". You are right, I should revert the other
header additions.

>
> > +
> > +struct ucall_header {
> > +     DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
> > +     struct ucall ucalls[KVM_MAX_VCPUS];
> > +};
> > +
> > +static bool encrypted_guest;
> > +static struct ucall_header *ucall_hdr;
> > +
> > +void ucall_init(struct kvm_vm *vm, void *arg)
> > +{
> > +     struct ucall *uc;
> > +     struct ucall_header *hdr;
> > +     vm_vaddr_t vaddr;
> > +     int i;
> > +
> > +     encrypted_guest = vm->memcrypt.enabled;
> > +     sync_global_to_guest(vm, encrypted_guest);
> > +     if (!encrypted_guest)
> > +             goto out;
> > +
> > +     TEST_ASSERT(!ucall_hdr,
> > +                 "Only a single encrypted guest at a time for ucalls.");
> > +     vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), vm->page_size);
> > +     hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
> > +     memset(hdr, 0, sizeof(*hdr));
> > +
> > +     for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> > +             uc = &hdr->ucalls[i];
> > +             uc->hva = uc;
> > +             uc->idx = i;
> > +     }
> > +
> > +     ucall_hdr = (struct ucall_header *)vaddr;
> > +     sync_global_to_guest(vm, ucall_hdr);
> > +
> > +out:
> > +     ucall_arch_init(vm, arg);
> > +}
> > +
> > +void ucall_uninit(struct kvm_vm *vm)
> > +{
> > +     encrypted_guest = false;
> > +     ucall_hdr = NULL;
> > +
> > +     ucall_arch_uninit(vm);
> > +}
> > +
> > +static struct ucall *ucall_alloc(void)
> > +{
> > +     struct ucall *uc = NULL;
> > +     int i;
> > +
> > +     if (!encrypted_guest)
> > +             goto out;
> > +
> > +     for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> > +             if (atomic_test_and_set_bit(i, ucall_hdr->in_use))
> > +                     continue;
> > +
> > +             uc = &ucall_hdr->ucalls[i];
>
> Doesn't this just mark all buffers as in-use and return the last one?
> I think we want
>
>         for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>                 if (!atomic_test_and_set_bit(i, ucall_hdr->in_use)) {
>                         uc = &ucall_hdr->ucalls[i];
>                         break;
>                 }
>         }

Yes, that looks correct. I'll update this.
>
> > +     }
> > +
> > +out:
> > +     return uc;
> > +}
> > +
> > +static void ucall_free(struct ucall *uc)
> > +{
> > +     if (!encrypted_guest)
> > +             return;
> > +
> > +     clear_bit(uc->idx, ucall_hdr->in_use);
> > +}
> > +
> > +static vm_vaddr_t get_ucall_addr(struct ucall *uc)
> > +{
> > +     if (encrypted_guest)
> > +             return (vm_vaddr_t)uc->hva;
> > +
> > +     return (vm_vaddr_t)uc;
> > +}
> >
> >  void ucall(uint64_t cmd, int nargs, ...)
> >  {
> > -     struct ucall uc = {
> > -             .cmd = cmd,
> > -     };
> > +     struct ucall *uc;
> > +     struct ucall tmp;
> >       va_list va;
> >       int i;
> >
> > +     uc = ucall_alloc();
> > +     if (!uc)
> > +             uc = &tmp;
> > +
> > +     uc->cmd = cmd;
> > +
> >       nargs = min(nargs, UCALL_MAX_ARGS);
> >
> >       va_start(va, nargs);
> >       for (i = 0; i < nargs; ++i)
> > -             uc.args[i] = va_arg(va, uint64_t);
> > +             uc->args[i] = va_arg(va, uint64_t);
> >       va_end(va);
> >
> > -     ucall_arch_do_ucall((vm_vaddr_t)&uc);
> > +     ucall_arch_do_ucall(get_ucall_addr(uc));
> > +
> > +     ucall_free(uc);
> > +}
> > +
> > +void *get_ucall_hva(struct kvm_vm *vm, void *uc)
> > +{
> > +     if (encrypted_guest)
> > +             return uc;
> > +
> > +     return addr_gva2hva(vm, (vm_vaddr_t)uc);
> >  }
> >
> >  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> > @@ -27,9 +128,9 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> >       if (!uc)
> >               uc = &ucall;
> >
> > -     addr = ucall_arch_get_ucall(vcpu);
> > +     addr = get_ucall_hva(vcpu->vm, ucall_arch_get_ucall(vcpu));
>
> Hmm... so now it's expected that ucall_arch_get_ucall() returns a gva...
>
> >       if (addr) {
> > -             memcpy(uc, addr, sizeof(*uc));
> > +             memcpy(uc, addr, sizeof(struct ucall));
>
> Why make this change?

I'll revert this.

>
> >               vcpu_run_complete_io(vcpu);
> >       } else {
> >               memset(uc, 0, sizeof(*uc));
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > index ec53a406f689..ea6b2e3a8e39 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> > @@ -30,7 +30,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
> >               struct kvm_regs regs;
> >
> >               vcpu_regs_get(vcpu, &regs);
> > -             return addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi);
> > +             return (void *)regs.rdi;
>
> ...we're only updating x86's ucall_arch_get_ucall() to return gvas.
> What about the other architectures? Anyway, I'd rather we don't
> change ucall_arch_get_ucall() to return gvas. They should continue
> returning hvas and any trickery needed to translate a pool uc to
> an hva should be put inside ucall_arch_get_ucall().

Makes sense. I'll maintain returning HVAs in both cases and let the
_arch_ calls handle the translations.

>
> >       }
> >       return NULL;
> >  }
> > --
> > 2.37.0.170.g444d1eabd0-goog
> >
>
> I'm not a big fan of mixing the concept of encrypted guests into ucalls. I
> think we should have two types of ucalls, those have a uc pool in memory
> shared with the host and those that don't. Encrypted guests pick the pool
> version.

Sean suggested this version where encrypted guests and normal guests
used the same ucall macros/functions. I am fine with adding a second
interface for encrypted VM ucall, do you think macros like
ENCRYPTED_GUEST_SYNC, ENCRYPTED_GUEST_ASSERT, and
get_encrypted_ucall() ?


>
> Thanks,
> drew
