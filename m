Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C27F1DD1
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 19:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfKFSyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 13:54:21 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:40615 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfKFSyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 13:54:21 -0500
Received: by mail-il1-f194.google.com with SMTP id d83so22772953ilk.7
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 10:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u0vHObioO00op6viCjEuOxXjOJqUITZMRxfciFPdeNE=;
        b=VSY2gq5xWjX7c5Dk7z0GBly+lzCFEAXZWhwjzZM+RipoR64TG0tzQMEsgi3zEzOOYv
         BYSv+hDjR92hxHJ5LgWb0S9eKFk9FBfu2Zz8IjlSBNb1y+j9sbYcqH85PEl7oj0qxtUo
         YCgA0d5i/YOfdj7hZ6H1oWZZpiZ/WAgoFuXq+AM4qtUDIYaSDjrhxrv11kjOG9UdZvGD
         Y/REMLFMUBop5gRHx9uSl28V5BKoPIXZyUwNaC9YDcOh/8hpdkEJT+6WXkuzt8HaxHgx
         KZ1WE4XDCoaDAyiWbIrQuz7TutzDdXGVaIhAlUlTAjeGiLckkksmC2lMxeR9OZrU7bHg
         9D4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u0vHObioO00op6viCjEuOxXjOJqUITZMRxfciFPdeNE=;
        b=QS16kw9GYsz5Fv7ZkqwoAaStO2I35S5whav6mskg1ytwX69uu+A+aaYLdPtkrxMB3A
         aFmcJMtcJpyAPLgbofDkM3PH88W1vstZ9k7s57P2UntoPe45HSWrrn5go6B6UWgr06Fs
         +h0xr5OV9X5NuEcVqJXu1Ehk43QiGVXLjZ7/BhYSwMORGhb7rW9YLfPLkNiTKU0x3WAd
         RGYzbo6r6KOk0QeBsqY7guNEeYC6sN+UxSZR78jDKKa6PGiAOxMfNFqiBFNL2jiN2JVt
         D254ZRt7kBnuHTo+toPuy3JJ+Mooxw0y5KEUl1qcq8qDAZI4QxJqZlPS/Bf86SCUbNzO
         RWtw==
X-Gm-Message-State: APjAAAUAhyi81Stn/90wTbe204mA2maD50PoMXkn9SG1nz1YOh1ZktxA
        lztMiplsqfss5OxIiEFZzuQPFXca/AAJkVIFOztyKQ==
X-Google-Smtp-Source: APXvYqwAlcNedWzgYAg2W+/EgKwFIZDEQX5d7LZAHY0vk67lIq+gxioFHRi7PA1DFXGb5PWraWwOZDsx5tcQ0nQu5g4=
X-Received: by 2002:a92:8983:: with SMTP id w3mr4754916ilk.108.1573066459879;
 Wed, 06 Nov 2019 10:54:19 -0800 (PST)
MIME-Version: 1.0
References: <20191105191910.56505-1-aaronlewis@google.com> <20191105191910.56505-5-aaronlewis@google.com>
 <20191105224847.GB23297@linux.intel.com>
In-Reply-To: <20191105224847.GB23297@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Nov 2019 10:54:08 -0800
Message-ID: <CALMp9eQ3UD+WAZOTfmHKmZJ7QYixGEkBSQSyLYh0CdDwP1yFPw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: nVMX: Add support for capturing highest
 observable L2 TSC
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 5, 2019 at 2:49 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Nov 05, 2019 at 11:19:10AM -0800, Aaron Lewis wrote:
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
>
> Given that this is a one-off case for a nested guest, is it really worth
> adding the infrastructure to allow storing arbitrary MSRs on exit?  The
> MSR list isn't any faster than plain ol' RDMSR, so the only use case is
> likely limited to something like this, e.g. prior to this nested case, KVM
> has existed for well over a decade without needing to store an MSR on
> VM-Exit.
>
> Making this a truly one-off case would eliminate most of the refactoring
> and would avoid the bikeshedding in patch 2/2 over how to rename
> NR_AUTOLOAD_MSRS (I hate the term "AUTO" for whatever reason).

I thought bikeshedding was de rigueur for kvm submissions. :-) And I'm
with you on "AUTO."

>
> E.g.:
>
> prepare_vmcs02_constant_state()
>
>         vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->nested.l2_tsc));
>
> prepare_vmcs02_rare():
>
>         if (nested_msr_store_list_has_msr(vcpu, MSR_IA32_TSC))
>                 vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 1);
>         else
>                 vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
>
>

That seems like a bit of a hack, to be honest. (And if we're going
that way, why not continue down the slippery slope and abandon
nested_msr_store_list_has_msr for nested_msr_store_list_has_tsc?)

> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 92 ++++++++++++++++++++++++++++++++++++---
> >  arch/x86/kvm/vmx/vmx.h    |  4 ++
> >  2 files changed, 90 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 7b058d7b9fcc..cb2a92341eab 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -929,6 +929,37 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
> >       return i + 1;
> >  }
> >
> > +static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
> > +                                         u32 msr_index,
> > +                                         u64 *data)
> > +{
> > +     struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +
> > +     /*
> > +      * If the L0 hypervisor stored a more accurate value for the TSC that
> > +      * does not include the time taken for emulation of the L2->L1
> > +      * VM-exit in L0, use the more accurate value.
> > +      */
> > +     if (msr_index == MSR_IA32_TSC) {
> > +             int index = vmx_find_msr_index(&vmx->msr_autostore.guest,
> > +                                            MSR_IA32_TSC);
> > +
> > +             if (index >= 0) {
> > +                     u64 val = vmx->msr_autostore.guest.val[index].value;
> > +
> > +                     *data = kvm_read_l1_tsc(vcpu, val);
> > +                     return true;
> > +             }
> > +     }
> > +
> > +     if (kvm_get_msr(vcpu, msr_index, data)) {
> > +             pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
> > +                     msr_index);
> > +             return false;
> > +     }
> > +     return true;
> > +}
> > +
> >  static bool read_and_check_msr_entry(struct kvm_vcpu *vcpu, u64 gpa, int i,
> >                                    struct vmx_msr_entry *e)
> >  {
> > @@ -963,12 +994,9 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
> >               if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
> >                       return -EINVAL;
> >
> > -             if (kvm_get_msr(vcpu, e.index, &data)) {
> > -                     pr_debug_ratelimited(
> > -                             "%s cannot read MSR (%u, 0x%x)\n",
> > -                             __func__, i, e.index);
> > +             if (!nested_vmx_get_vmexit_msr_value(vcpu, e.index, &data))
> >                       return -EINVAL;
> > -             }
> > +
> >               if (kvm_vcpu_write_guest(vcpu,
> >                                        gpa + i * sizeof(e) +
> >                                            offsetof(struct vmx_msr_entry, value),
> > @@ -982,6 +1010,51 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
> >       return 0;
> >  }
> >
> > +static bool nested_msr_store_list_has_msr(struct kvm_vcpu *vcpu, u32 msr_index)
> > +{
> > +     struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> > +     u32 count = vmcs12->vm_exit_msr_store_count;
> > +     u64 gpa = vmcs12->vm_exit_msr_store_addr;
> > +     struct vmx_msr_entry e;
> > +     u32 i;
> > +
> > +     for (i = 0; i < count; i++) {
> > +             if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
> > +                     return false;
> > +
> > +             if (e.index == msr_index)
> > +                     return true;
> > +     }
> > +     return false;
> > +}
> > +
> > +static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
> > +                                        u32 msr_index)
> > +{
> > +     struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +     struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
> > +     int i = vmx_find_msr_index(autostore, msr_index);
> > +     bool in_autostore_list = i >= 0;
> > +     bool in_vmcs12_store_list;
> > +     int last;
> > +
> > +     in_vmcs12_store_list = nested_msr_store_list_has_msr(vcpu, msr_index);
> > +
> > +     if (in_vmcs12_store_list && !in_autostore_list) {
> > +             if (autostore->nr == NR_MSR_ENTRIES) {
> > +                     pr_warn_ratelimited(
> > +                             "Not enough msr entries in msr_autostore.  Can't add msr %x\n",
> > +                             msr_index);
> > +                     return;
> > +             }
> > +             last = autostore->nr++;
> > +             autostore->val[last].index = msr_index;
> > +     } else if (!in_vmcs12_store_list && in_autostore_list) {
> > +             last = --autostore->nr;
> > +             autostore->val[i] = autostore->val[last];
> > +     }
> > +}
> > +
> >  static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
> >  {
> >       unsigned long invalid_mask;
> > @@ -2027,7 +2100,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
> >        * addresses are constant (for vmcs02), the counts can change based
> >        * on L2's behavior, e.g. switching to/from long mode.
> >        */
> > -     vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
> > +     vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
> >       vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
> >       vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));
> >
> > @@ -2294,6 +2367,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> >               vmcs_write64(EOI_EXIT_BITMAP3, vmcs12->eoi_exit_bitmap3);
> >       }
> >
> > +     /*
> > +      * Make sure the msr_autostore list is up to date before we set the
> > +      * count in the vmcs02.
> > +      */
> > +     prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
> > +
> > +     vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.guest.nr);
> >       vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> >       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 34b5fef603d8..0ab1562287af 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -230,6 +230,10 @@ struct vcpu_vmx {
> >               struct vmx_msrs host;
> >       } msr_autoload;
> >
> > +     struct msr_autostore {
> > +             struct vmx_msrs guest;
> > +     } msr_autostore;
> > +
> >       struct {
> >               int vm86_active;
> >               ulong save_rflags;
> > --
> > 2.24.0.rc1.363.gb1bccd3e3d-goog
> >
