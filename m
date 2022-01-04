Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B796483D2D
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 08:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiADHsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 02:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiADHsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 02:48:20 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CEDC061761
        for <kvm@vger.kernel.org>; Mon,  3 Jan 2022 23:48:20 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so5511774otl.8
        for <kvm@vger.kernel.org>; Mon, 03 Jan 2022 23:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VWqmU/y1nIqAOlg54TR7mYd4X0rg4PYnPJyfRf3daX0=;
        b=UTsI9totBvZwG+PeFsS0c2v8YJW8lGplFcak49CLuSCh3bl30qZNcuCuh5IM3bgn3K
         sRJRmCQ/eyHkjIlzTELDbpGp7bCCjZYuw417eDMUnQfN+1aPQfChggH48eOwrqCtj5Mw
         PudkREmEjyhB9BJDOzssvWV1pM33al7c5xoXv4l7tEj/d+p9TtrN1vsvYr5smVn0MDZz
         J6jg2ih82v8z2Lvqj0B0OzbtFnTYRlz4ZVgENwmzWqOQl21w9IrcoN2dnjAI4glhqtqa
         WERBszEo6X8L91JdWz6G1DcYutNb5JMEMYWfWU7ENjXW3gcARZzdIIdlAGkpD8uPpfJ/
         wSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VWqmU/y1nIqAOlg54TR7mYd4X0rg4PYnPJyfRf3daX0=;
        b=HGDFI7w814YtQblJcw9WT2JADbSQ3ERzHdPsDxuNHLHuiEh+X45oMWcNDyO0hHiz/E
         Wf1ZA5HwwZYjcHvRrfJ9Aq9FJbjEHFZaDLkHSMBXw8qF8Kicnf1qpcaLkzvYvacjXgxJ
         hCSYGa7RyTE5w+FSfBOOkwGwfrj+i5K48GJveBm30G3yIMZC5lNjARFahqAnp3AiNkI1
         xVWKC4hhRHU9GU1KLhjLnl7d77kuhWodaDOtaGgcDqo+7pmh1nxesX9tT86Rl53E5hnM
         6fDnaHQflI3+7ZbrWhUw+syG7R/VPOCh9a7jZuzTl50KIjjGf7XN+2wOgdoAiydygc5t
         MSHw==
X-Gm-Message-State: AOAM533V52bzJvM8Nm61aTLsPpRqYTlmZXlqJ2hb8A7thl22ZBSogkE4
        uPlxy7nR4b6WhDbrNLBArygEt7nvAePwCzGNkOE=
X-Google-Smtp-Source: ABdhPJw4g7znlfwqRRwwdeoU8jHvJactStpmtNizYbzJtfJE+dpnsx/4k/paNA+CrLnMBvduFHJmpzd9qoho76rm7II=
X-Received: by 2002:a9d:200b:: with SMTP id n11mr35201425ota.169.1641282499879;
 Mon, 03 Jan 2022 23:48:19 -0800 (PST)
MIME-Version: 1.0
References: <20211210163625.2886-1-dwmw2@infradead.org> <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
 <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com> <YcTpJ369cRBN4W93@google.com>
In-Reply-To: <YcTpJ369cRBN4W93@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 4 Jan 2022 15:48:08 +0800
Message-ID: <CANRm+CzLWedbVHapQbVCRDoU=0HFkwq6Vgw4_+8=oc6zXd_7UA@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 25 Dec 2021 at 09:19, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Dec 23, 2021, Paolo Bonzini wrote:
> > On 12/22/21 16:18, David Woodhouse wrote:
> > > > > n a mapped
> > > > > shared info page.
> > > > >
> > > > > This can be used for routing MSI of passthrough devices to PIRQ event
> > > > > channels in a Xen guest, and we can build on it for delivering IPIs and
> > > > > timers directly from the kernel too.
> > > > Queued patches 1-5, thanks.
> > > >
> > > > Paolo
> > > Any word on when these will make it out to kvm.git? Did you find
> > > something else I need to fix?
> >
> > I got a WARN when testing the queue branch, now I'm bisecting.
>
> Was it perhaps this WARN?
>
>   WARNING: CPU: 5 PID: 2180 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3163 mark_page_dirty_in_slot+0x6b/0x80 [kvm]
>   Modules linked in: kvm_intel kvm irqbypass
>   CPU: 5 PID: 2180 Comm: hyperv_clock Not tainted 5.16.0-rc4+ #81
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:mark_page_dirty_in_slot+0x6b/0x80 [kvm]
>    kvm_write_guest+0x117/0x120 [kvm]
>    kvm_hv_invalidate_tsc_page+0x99/0xf0 [kvm]
>    kvm_arch_vm_ioctl+0x20f/0xb60 [kvm]
>    kvm_vm_ioctl+0x711/0xd50 [kvm]
>    __x64_sys_ioctl+0x7f/0xb0
>    do_syscall_64+0x38/0xc0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> If so, it was clearly introduced by commit 03c0304a86bc ("KVM: Warn if mark_page_dirty()
> is called without an active vCPU").  But that change is 100% correct as it's trivial
> to crash KVM without its protection.  E.g. running hyper_clock with these mods
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 2dd78c1db4b6..ae0d0490580a 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -371,6 +371,8 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>         vm_create_irqchip(vm);
>  #endif
>
> +       vm_enable_dirty_ring(vm, 0x10000);
> +
>         for (i = 0; i < nr_vcpus; ++i) {
>                 uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
>
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> index e0b2bb1339b1..1032695e3901 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> @@ -212,6 +212,8 @@ int main(void)
>         vm = vm_create_default(VCPU_ID, 0, guest_main);
>         run = vcpu_state(vm, VCPU_ID);
>
> +       vm_mem_region_set_flags(vm, 0, KVM_MEM_LOG_DIRTY_PAGES);
> +
>         vcpu_set_hv_cpuid(vm, VCPU_ID);
>
>         tsc_page_gva = vm_vaddr_alloc_page(vm);
>
> Triggers a NULL pointer deref.
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 12959a067 P4D 12959a067 PUD 129594067 PMD 0
>   Oops: 0000 [#1] SMP
>   CPU: 5 PID: 1784 Comm: hyperv_clock Not tainted 5.16.0-rc4+ #82
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:kvm_dirty_ring_get+0xe/0x30 [kvm]
>    mark_page_dirty_in_slot.part.0+0x30/0x60 [kvm]
>    kvm_write_guest+0x117/0x130 [kvm]
>    kvm_hv_invalidate_tsc_page+0x99/0xf0 [kvm]
>    kvm_arch_vm_ioctl+0x20f/0xb60 [kvm]
>    kvm_vm_ioctl+0x711/0xd50 [kvm]
>    __x64_sys_ioctl+0x7f/0xb0
>    do_syscall_64+0x38/0xc0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae

I saw this warning by running vanilla hyperv_clock w/o modifying
against kvm/queue.

>
> Commit e880c6ea55b9 ("KVM: x86: hyper-v: Prevent using not-yet-updated TSC page
> by secondary CPUs") is squarely to blame as it was added after dirty ring, though
> in Vitaly's defense, David put it best: "That's a fairly awful bear trap".
>
> Assuming there's nothing special about vcpu0's clock, I belive the below fixes
> all issues.  If not, then the correct fix is to have vcpu0 block all other vCPUs
> until the update completes.

Could we invalidate hv->tsc_ref.tsc_sequence directly w/o marking page
dirty since after migration it is stale until the first successful
kvm_hv_setup_tsc_page() call?

    Wanpeng
