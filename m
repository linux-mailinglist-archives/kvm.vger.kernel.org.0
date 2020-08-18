Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D48924902F
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgHRVel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgHRVek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:34:40 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D84BC061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:34:39 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id v22so16447591edy.0
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xVaMYKrwcBky44ogrCeXbAfuQLqSrfd9XAy3zfNJUQc=;
        b=qc0fNRGSUuYFhvtm0r7VkzABEPiyXUDkTZKRidlYJgjvOtFQu2y+MEOJ8ADhKT1qZH
         Lh+Ixd/GhKf6dan0cgvjrJUKZ5SPj//QHzuplcH5sQkPU0Fkwz+zW8XlBOwMkYzYhmZt
         exRXZN1HkNuM7o89FybBme0aKeO8r2pd7+RrAZ6iC81iLi4/klc5xbsi2pCkTfg5Ez8e
         DxyqTxVR8iF4vQdEtAnh8CtOPrB9807B3OaeSvBYUcXfLOdq9zxTLTecuyLho5BHeJHB
         rm0C33KXZ+lSl5W1zQ4q9XOGAsWC3YzIvuhMDU0z9KJsLyjRlqTy7+1nkIzxP0dm6QRH
         jxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xVaMYKrwcBky44ogrCeXbAfuQLqSrfd9XAy3zfNJUQc=;
        b=DmHSw1Qpxt7y8Nev8QAZhiluLm+pH68s6BXfifdladkRuQS7L/nKREfvK4MtsiGYtm
         TrVqoiFhHVzN0I59GlIHiTgW+gpzXu2QOgpV8wV49Y27362hy78WqVz/+XYZC33JL1Du
         pGk6AaQd5wCLZg1zzlOznFud+f2g3aB3Ujq84hnabXSJwVqXHeAiN2mqZWLxJ1U36iL1
         Pn1vlERv+6Ze2j9mpvqvEoVUMvrAEf+w9X6QyEtWy5orpihY651p4b/q1DckQSt0Oiup
         IBdPFRgLmUdoJmL9klO9zuv6liSBgPvnmETaNWonYQNLlThNWCPCkiiuQNUFzx4nOawl
         FKbQ==
X-Gm-Message-State: AOAM531b/f2OgujjiJM3/6PBZo99ylvtghSCRSKC/YPC756cZ3W/Zusp
        Q3v9M1hop3VRlFv/NcKGDs++aYvIMIRVFxG3QDQWPucHh2yqmw==
X-Google-Smtp-Source: ABdhPJzhzclG688yp4IWZUY+tywAGyCUaSPl1UP9PEXRrTfr2QZ5Tvs4TYWPBgGiYBWti+gqqoNPj03x3L5dVHt5Fiw=
X-Received: by 2002:a05:6402:1758:: with SMTP id v24mr22058553edx.274.1597786477688;
 Tue, 18 Aug 2020 14:34:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
 <20200804042043.3592620-5-aaronlewis@google.com> <617a3e8d-755e-c7b1-7927-d8c9f1da2c58@amazon.com>
In-Reply-To: <617a3e8d-755e-c7b1-7927-d8c9f1da2c58@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 18 Aug 2020 14:34:26 -0700
Message-ID: <CAAAPnDEga3t1fWY3RN9gVMFOwa09dXTzktUft0MTC4_BR_acAg@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
To:     Alexander Graf <graf@amazon.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 4:03 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 04.08.20 06:20, Aaron Lewis wrote:
> >
> > SDM volume 3: 24.6.9 "MSR-Bitmap Address" and APM volume 2: 15.11 "MS
> > intercepts" describe MSR permission bitmaps.  Permission bitmaps are
> > used to control whether an execution of rdmsr or wrmsr will cause a
> > vm exit.  For userspace tracked MSRs it is required they cause a vm
> > exit, so the host is able to forward the MSR to userspace.  This change
> > adds vmx/svm support to ensure the permission bitmap is properly set to
> > cause a vm_exit to the host when rdmsr or wrmsr is used by one of the
> > userspace tracked MSRs.  Also, to avoid repeatedly setting them,
> > kvm_make_request() is used to coalesce these into a single call.
>
> I might have some fundamental misunderstanding here:
>
> 1) You force that the list of trapped MSRs is set before vCPU creation,
> so at the point of vCPU creation, you know already which MSRs should
> trap to user space
>
> 2) MSR intercept bitmaps are (AFAIK) all set to "trap by default". That
> means any MSR that we want the guest to get direct access to needs
> explicit opt-in through bitmap modifications.
>
> That means if you simply check whether an MSR is supposed to trap to
> user space in the bitmap set path, you don't need any of the complicated
> logic below, no?
>
>
> Alex
>

Yes, I think that should work as well.  However, calling it after the
fact like we do does have a nice advantage of allowing us to coalesce
the calls and limit the number of times we need to search the list.

> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  3 ++
> >   arch/x86/kvm/svm/svm.c          | 49 ++++++++++++++++++++++++++-------
> >   arch/x86/kvm/vmx/vmx.c          | 13 ++++++++-
> >   arch/x86/kvm/x86.c              | 16 +++++++++++
> >   4 files changed, 70 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 510055471dd0..07a85f5f0b8a 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -87,6 +87,7 @@
> >   #define KVM_REQ_HV_TLB_FLUSH \
> >          KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
> >   #define KVM_REQ_APF_READY              KVM_ARCH_REQ(28)
> > +#define KVM_REQ_USER_MSR_UPDATE KVM_ARCH_REQ(29)
> >
> >   #define CR0_RESERVED_BITS                                               \
> >          (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> > @@ -1271,6 +1272,8 @@ struct kvm_x86_ops {
> >          int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> >
> >          void (*migrate_timers)(struct kvm_vcpu *vcpu);
> > +
> > +       void (*set_user_msr_intercept)(struct kvm_vcpu *vcpu, u32 msr);
> >   };
> >
> >   struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index eb673b59f7b7..c560d283b2af 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -583,13 +583,27 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
> >          return !!test_bit(bit_write,  &tmp);
> >   }
> >
> > +static void __set_msr_interception(u32 *msrpm, u32 msr, int read, int write,
> > +                                  u32 offset)
> > +{
> > +       u8 bit_read, bit_write;
> > +       unsigned long tmp;
> > +
> > +       bit_read  = 2 * (msr & 0x0f);
> > +       bit_write = 2 * (msr & 0x0f) + 1;
> > +       tmp       = msrpm[offset];
> > +
> > +       read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
> > +       write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
> > +
> > +       msrpm[offset] = tmp;
> > +}
> > +
> >   static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
> >                                   int write)
> >   {
> >          struct vcpu_svm *svm = to_svm(vcpu);
> >          u32 *msrpm = svm->msrpm;
> > -       u8 bit_read, bit_write;
> > -       unsigned long tmp;
> >          u32 offset;
> >
> >          /*
> > @@ -598,17 +612,30 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
> >           */
> >          WARN_ON(!valid_msr_intercept(msr));
> >
> > -       offset    = svm_msrpm_offset(msr);
> > -       bit_read  = 2 * (msr & 0x0f);
> > -       bit_write = 2 * (msr & 0x0f) + 1;
> > -       tmp       = msrpm[offset];
> > -
> > +       offset = svm_msrpm_offset(msr);
> >          BUG_ON(offset == MSR_INVALID);
> >
> > -       read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
> > -       write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
> > +       __set_msr_interception(msrpm, msr, read, write, offset);
> >
> > -       msrpm[offset] = tmp;
> > +       if (read || write)
> > +               kvm_make_request(KVM_REQ_USER_MSR_UPDATE, vcpu);
> > +}
> > +
> > +static void set_user_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
> > +                                     int write)
> > +{
> > +       struct vcpu_svm *svm = to_svm(vcpu);
> > +       u32 *msrpm = svm->msrpm;
> > +       u32 offset;
> > +
> > +       offset = svm_msrpm_offset(msr);
> > +       if (offset != MSR_INVALID)
> > +               __set_msr_interception(msrpm, msr, read, write, offset);
> > +}
> > +
> > +void svm_set_user_msr_intercept(struct kvm_vcpu *vcpu, u32 msr)
> > +{
> > +       set_user_msr_interception(vcpu, msr, 0, 0);
> >   }
> >
> >   static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
> > @@ -4088,6 +4115,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >          .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> >
> >          .apic_init_signal_blocked = svm_apic_init_signal_blocked,
> > +
> > +       .set_user_msr_intercept = svm_set_user_msr_intercept,
> >   };
> >
> >   static struct kvm_x86_init_ops svm_init_ops __initdata = {
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 1313e47a5a1e..3d3d9eaeca64 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -3728,6 +3728,10 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
> >                          __clear_bit(msr, msr_bitmap + 0xc00 / f);
> >
> >          }
> > +
> > +       if (type & MSR_TYPE_R || type & MSR_TYPE_W) {
> > +               kvm_make_request(KVM_REQ_USER_MSR_UPDATE, vcpu);
> > +       }
> >   }
> >
> >   static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
> > @@ -3795,7 +3799,7 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
> >   }
> >
> >   static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
> > -                                        unsigned long *msr_bitmap, u8 mode)
> > +                                       unsigned long *msr_bitmap, u8 mode)
> >   {
> >          int msr;
> >
> > @@ -3819,6 +3823,11 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
> >          }
> >   }
> >
> > +void vmx_set_user_msr_intercept(struct kvm_vcpu *vcpu, u32 msr)
> > +{
> > +       vmx_enable_intercept_for_msr(vcpu, msr, MSR_TYPE_RW);
> > +}
> > +
> >   void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
> >   {
> >          struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -7965,6 +7974,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> >          .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> >          .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> >          .migrate_timers = vmx_migrate_timers,
> > +
> > +       .set_user_msr_intercept = vmx_set_user_msr_intercept,
> >   };
> >
> >   static __init int hardware_setup(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 47619b49818a..45bf59f94d34 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3537,6 +3537,19 @@ bool kvm_msr_user_exit(struct kvm *kvm, u32 index)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_msr_user_exit);
> >
> > +static void kvm_set_user_msr_intercepts(struct kvm_vcpu *vcpu)
> > +{
> > +       struct kvm_msr_list *msr_list = vcpu->kvm->arch.user_exit_msrs;
> > +       u32 i, msr;
> > +
> > +       if (msr_list) {
> > +               for (i = 0; i < msr_list->nmsrs; i++) {
> > +                       msr = msr_list->indices[i];
> > +                       kvm_x86_ops.set_user_msr_intercept(vcpu, msr);
> > +               }
> > +       }
> > +}
> > +
> >   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >   {
> >          int r = 0;
> > @@ -8553,6 +8566,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >                          kvm_vcpu_update_apicv(vcpu);
> >                  if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
> >                          kvm_check_async_pf_completion(vcpu);
> > +
> > +               if (kvm_check_request(KVM_REQ_USER_MSR_UPDATE, vcpu))
> > +                       kvm_set_user_msr_intercepts(vcpu);
> >          }
> >
> >          if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
> > --
> > 2.28.0.163.g6104cc2f0b6-goog
> >
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
