Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE86B112035
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 00:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfLCXYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 18:24:13 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:38292 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfLCXYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 18:24:13 -0500
Received: by mail-il1-f195.google.com with SMTP id u17so4881851ilq.5
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 15:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=snfgGor+TmMvyRLPPsOqMsn204mo1+lOHUtWuYXLS9o=;
        b=nwzlrdoTu49v+A1Gk007cwFAmGonL2uTl7dlK7XrX6b9UwjT1SAI9FYWvohWpgTe85
         U97hV2R3yF5mvWMzcmhc/uY490WImQp8k4ZTlNMZId9qa4UOlsj7FuCxQ4rS8Nyhn57U
         rgE35JU5t9ADet3vw4KZjhRiZUPazxniKQ2yx4NIn0c0azToAUA4AeRhFt2M5LS9gnUp
         Yg1+r242jKEnMn7LA4VFsmrKLTsdmnXGd5lzktXYAfJiuC7KFB40fKeiJC8qCjASEnu8
         ZHraSqJib9jr5KSJCu6jfcJeXQL/u+d/Ue4aP+iwTDIy2jNiRlYoXmrnP9XUOfGwpUhp
         00lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=snfgGor+TmMvyRLPPsOqMsn204mo1+lOHUtWuYXLS9o=;
        b=UqF9Z/YfxQ+i2uPC+zVCng0DnC2WpdGy/PEfVLq0Iv21jskX4AOVnw9KteMsLckMea
         OGPsPVY48SThimvYPRYm9xg+EvTbVQzla6ujCqZnxP33IugVuIs1YushwAso6PVtHD/t
         0LWudEwPpp0zwkrqwEgCuHRmCjAFgDqvIprDBqlGmYDbLt9MrN/xIoX2GaiGZQ9ZzsT5
         ErJEUA8hdeilzRys5oVCdF75s0DSzQBmW4HO9gFNEu5HwbZWaRuKU7A32akEFardtfh8
         xxZFraShudHuifae8ECGHm13lTF1A5CWs98UDePZNEtGj0uWufmLldJdccBs5WEgCcXl
         TwvQ==
X-Gm-Message-State: APjAAAWcif2chYMbhFS3d6ioSDlFd5EyIleLTjZxamPpqSgx3cDnhKlw
        tvhFe2zH7tSMgweYI9DrxCRdlkkmeEU7Xjj2YR8Cv8ddzhHbYQ==
X-Google-Smtp-Source: APXvYqzKF6ktCBSGoWNa1tGRgNtNv3ytG1vtIyZvmgmOuCICcNb14tVgA45017FKdAax35ZaKyqcqF2/NBcn5dSfT5c=
X-Received: by 2002:a92:8983:: with SMTP id w3mr850389ilk.108.1575415451753;
 Tue, 03 Dec 2019 15:24:11 -0800 (PST)
MIME-Version: 1.0
References: <20191203210825.26827-1-jmattson@google.com> <20191203225918.GO19877@linux.intel.com>
In-Reply-To: <20191203225918.GO19877@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 3 Dec 2019 15:24:00 -0800
Message-ID: <CALMp9eRXD=LkfKn+4bsi_K--+SMHioTrcaTnJ8bPK60RH9vOug@mail.gmail.com>
Subject: Re: [PATCH] kvm: vmx: Stop wasting a page for guest_msrs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 3, 2019 at 2:59 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Dec 03, 2019 at 01:08:25PM -0800, Jim Mattson wrote:
> > We will never need more guest_msrs than there are indices in
> > vmx_msr_index. Thus, at present, the guest_msrs array will not exceed
> > 168 bytes.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 14 ++------------
> >  arch/x86/kvm/vmx/vmx.h |  8 +++++++-
> >  2 files changed, 9 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 1b9ab4166397d..0b3c7524456f1 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -443,7 +443,7 @@ static unsigned long host_idt_base;
> >   * support this emulation, IA32_STAR must always be included in
> >   * vmx_msr_index[], even in i386 builds.
> >   */
> > -const u32 vmx_msr_index[] = {
> > +const u32 vmx_msr_index[NR_GUEST_MSRS] = {
>
> What if we keep this as is and add
>
>         BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != NR_SHARED_MSRS);
>
> in setup_msrs()?  That way the build will fail if someone adds an MSR but
> forgets to update the #define.  With this change, gcc only spits out a
> warning if the number of elements exceeds the size of the array and
> presumably drops the extra elements on the floor.

Instead of setup_msrs(), what if I add that BUILD_BUG_ON() in
vmx_create_vcpu(), where I'm getting rid of the old BUILD_BUG_ON()
regarding ARRAY_SIZE(vmx_msr_index)?

> >  #ifdef CONFIG_X86_64
> >       MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
> >  #endif
> > @@ -6666,7 +6666,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
> >       free_vpid(vmx->vpid);
> >       nested_vmx_free_vcpu(vcpu);
> >       free_loaded_vmcs(vmx->loaded_vmcs);
> > -     kfree(vmx->guest_msrs);
> >       kvm_vcpu_uninit(vcpu);
> >       kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
> >       kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
> > @@ -6723,13 +6722,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
> >                       goto uninit_vcpu;
> >       }
> >
> > -     vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
> > -     BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) * sizeof(vmx->guest_msrs[0])
> > -                  > PAGE_SIZE);
> > -
> > -     if (!vmx->guest_msrs)
> > -             goto free_pml;
> > -
> >       for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
> >               u32 index = vmx_msr_index[i];
> >               u32 data_low, data_high;
> > @@ -6760,7 +6752,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
> >
> >       err = alloc_loaded_vmcs(&vmx->vmcs01);
> >       if (err < 0)
> > -             goto free_msrs;
> > +             goto free_pml;
> >
> >       msr_bitmap = vmx->vmcs01.msr_bitmap;
> >       vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
> > @@ -6822,8 +6814,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
> >
> >  free_vmcs:
> >       free_loaded_vmcs(vmx->loaded_vmcs);
> > -free_msrs:
> > -     kfree(vmx->guest_msrs);
> >  free_pml:
> >       vmx_destroy_pml_buffer(vmx);
> >  uninit_vcpu:
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 7c1b978b2df44..08bc24fa59909 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -22,6 +22,12 @@ extern u32 get_umwait_control_msr(void);
> >
> >  #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
> >
> > +#ifdef CONFIG_X86_64
> > +#define NR_GUEST_MSRS        7
> > +#else
> > +#define NR_GUEST_MSRS        4
> > +#endif
>
> As much as I hate the "shared msrs" terminology, "guest msrs" is even
> more confusing and misleading.  NR_SHARED_MSRS?
>
> > +
> >  #define NR_LOADSTORE_MSRS 8
> >
> >  struct vmx_msrs {
> > @@ -206,7 +212,7 @@ struct vcpu_vmx {
> >       u32                   idt_vectoring_info;
> >       ulong                 rflags;
> >
> > -     struct shared_msr_entry *guest_msrs;
> > +     struct shared_msr_entry guest_msrs[NR_GUEST_MSRS];
> >       int                   nmsrs;
> >       int                   save_nmsrs;
> >       bool                  guest_msrs_ready;
> > --
> > 2.24.0.393.g34dc348eaf-goog
> >
