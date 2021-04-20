Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD93365061
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 04:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhDTCeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 22:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTCeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 22:34:16 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1963BC06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 19:33:46 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so34544959otn.1
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 19:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2YASYiNW4GYlT1VJPkWeAiPvogJBv6t7fDZPBpBZqM=;
        b=mw67iJCf2W+0IQyupLCXl1zQCOgzZbSmGXMTpSE1/jTXHkIfZfJU1G8YbKACbroVa3
         H9AYu0LlFlHGdQhSTxq+x7URzTx3dX2vtCCU3id/QIv6M7XJs123yX4q0IS2SCmkIf1X
         sZNOUAn72CKRUOYRRXe8ZjO3/PhqHuuRm7lIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2YASYiNW4GYlT1VJPkWeAiPvogJBv6t7fDZPBpBZqM=;
        b=kAAg/nMJ3rr71e85gCaprbl84Lsi62DSVtOtISglvANyUKg3o+8Ij926OKARy92xPq
         Dce9EBM61otevfkpeBbo5wqzvsffgu6EPP1/9ke7feJfijea2LgPrpz/SF5THidDUJw4
         oSY5zmtIDHsCDEOVQFMcdHXGt4Gg2/vzlLuRweuSeXMuEZ9l0xcjgX54OHmJb4KHCJ2C
         f6Ux17gG40+TP5lh5l/DWy/Rp4Y343TnoNJGz38pQ+nkb+lmPt70hAKARDHamqzRD9+Q
         ZngVoJO4Tay+o8NX0sV4ixTHD0l8nuVi8Crd9HBRa2DAa7HLjmxHBHdt4JdxpLAe/Mk5
         bMuw==
X-Gm-Message-State: AOAM533xnmr2/YytyXyLnFIdcU0I+WDEEvk6srFofoS7GF2rXQIVfsv3
        8dejQVk9dzv/eX3Z3Z9OOhTlkBiUZpwi10Q5tsmBSxzaDAg=
X-Google-Smtp-Source: ABdhPJxtpnu+6vh5rViQnb8KFkVV6LI1xGWHg/oRkhaajYQE7XIeATRi7S9mikyRI7jXFhLiOvom+S2aWYjlpJi5SEA=
X-Received: by 2002:a05:6830:2241:: with SMTP id t1mr17173521otd.126.1618886025495;
 Mon, 19 Apr 2021 19:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GKd_YR9QmTR-6KsiE16=4s8fuqh8pmQTYnxHXS=mYp9g@mail.gmail.com>
 <YH2z3uuQYwSyGJfL@google.com>
In-Reply-To: <YH2z3uuQYwSyGJfL@google.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Tue, 20 Apr 2021 08:03:34 +0530
Message-ID: <CAJGDS+FGnDFssYXLfLrog+AJu62rrs6DzAQuESJSDaNNdsYdcw@mail.gmail.com>
Subject: Re: Intercepting RDTSC instruction by causing a VMEXIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

Thank you very much for your answer. I'm hoping the inlined changes
should be enough to see RDTSC interception.

No, I'm actually not running a nested guest, even though vmx is enabled.

Best Regards,
Arnabjyoti Kalita

On Mon, Apr 19, 2021 at 10:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, Apr 17, 2021, Arnabjyoti Kalita wrote:
> > Hello all,
> >
> > I'm having a requirement to record values obtained by reading tsc clock.
> >
> > The command line I use to start QEMU in KVM mode is as below -
> >
> > sudo ./qemu-system-x86_64 -m 1024 --machine pc-i440fx-2.5 -cpu
> > qemu64,-vme,-x2apic,-kvmclock,+lahf_lm,+3dnowprefetch,+vmx -enable-kvm
> > -netdev tap,id=tap1,ifname=tap0,script=no,downscript=no -device
> > virtio-net-pci,netdev=tap1,mac=00:00:00:00:00:00 -drive
> > file=~/os_images_for_qemu/ubuntu-16.04.server.qcow2,format=qcow2,if=none,id=img-direct
> > -device virtio-blk-pci,drive=img-direct
> >
> > I am using QEMU version 2.11.92 and the guest kernel is a
> > 4.4.0-116-generic. I use the CPU model "qemu64" because I have a
> > requirement to create a snapshot of this guest and load the snapshot
> > in TCG mode. The generic CPU model helps, in this regard.
> >
> > Now when the guest is running, I want to intercept all rdtsc
> > instructions and record the tsc clock values. I know that for this to
> > happen, the CPU_BASED_RDTSC_EXITING flag needs to exist for the
> > particular CPU model.
> >
> > How do I start adding support for causing VMEXIT upon rdtsc execution?
>
> This requires a KVM change.  The below should do the trick.
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c05e6e2854b5..f000728e4319 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2453,7 +2453,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>               CPU_BASED_MWAIT_EXITING |
>               CPU_BASED_MONITOR_EXITING |
>               CPU_BASED_INVLPG_EXITING |
> -             CPU_BASED_RDPMC_EXITING;
> +             CPU_BASED_RDPMC_EXITING |
> +             CPU_BASED_RDTSC_EXITING;
>
>         opt = CPU_BASED_TPR_SHADOW |
>               CPU_BASED_USE_MSR_BITMAPS |
> @@ -5194,6 +5195,15 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
>         return kvm_skip_emulated_instruction(vcpu);
>  }
>
> +static int handle_rdtsc(struct kvm_vcpu *vcpu)
> +{
> +       u64 tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> +
> +       kvm_rax_write(vcpu, tsc & -1u);
> +       kvm_rdx_write(vcpu, (tsc >> 32) & -1u);
> +       return kvm_skip_emulated_instruction(vcpu);
> +}
> +
>  static int handle_apic_access(struct kvm_vcpu *vcpu)
>  {
>         if (likely(fasteoi)) {
> @@ -5605,6 +5615,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>         [EXIT_REASON_INVD]                    = kvm_emulate_invd,
>         [EXIT_REASON_INVLPG]                  = handle_invlpg,
>         [EXIT_REASON_RDPMC]                   = kvm_emulate_rdpmc,
> +       [EXIT_REASON_RDTSC]                   = handle_rdtsc,
>         [EXIT_REASON_VMCALL]                  = kvm_emulate_hypercall,
>         [EXIT_REASON_VMCLEAR]                 = handle_vmx_instruction,
>         [EXIT_REASON_VMLAUNCH]                = handle_vmx_instruction,
>
> > I see that a fairly recent commit in QEMU helps adding nested VMX
> > controls to named CPU models, but not "qemu64". Can I extend this
> > commit to add these controls to "qemu64" as well? Will making this
> > change immediately add support for intercepting VMEXITS for "qemu64"
> > CPU?
>
> Are you actually running a nested guest?
