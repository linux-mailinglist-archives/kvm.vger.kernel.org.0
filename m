Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35036323430
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 00:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhBWXZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 18:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbhBWXTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 18:19:49 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8A7C06178A
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 15:19:07 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id h22so385773otr.6
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 15:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dRXoBDgFZIgD9+/8HNqkE5zY8pCw7BmfPg5XxXSAbIs=;
        b=mVKXk2bMH060FPg+WmGqt0nUnrkjnTuiNcf0GH2M4keakiQ6qIkznBVX4NBwGN4bhN
         qI5bpffiHUxCSNtJqjIuq9tBlnWoGwo9XCLz2hdCQHOwScpeaSqCxez1KiVINyzV0Bmx
         bIWqfiHiwP8HApIl5As5mecCbqim9KRpJ8Horkb+EUH2zN3tusxExi8ISutmVS8DxGuA
         vAhGWXCkNtiiBOrI3kVKgMTCZ39l7hYDbphinX2jOuTEy7RVsiqSK5vlWVg9jW+qqKvF
         3WeUinQSL39T5HNH8K1G1ewfLibgnwz4U3RPneBr9EAIkoaBPBe9sfiAHQB3x84G1zW4
         +5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dRXoBDgFZIgD9+/8HNqkE5zY8pCw7BmfPg5XxXSAbIs=;
        b=EVmmuVlL2gW7Tf4xOHiKKkUhBuftpyPVHRSitJarmeoVax3cFj6ZUdx4y5yaXq13rU
         zCGJ48Qg2e7s+zAYZabmcX4ZNQAGB3ZOJh2DhD2BjcYAPNxzCrlS+Y/dElol+Vl80tNU
         1Uy7nq0If38zFaLrRLtIHt5H5X7VqsZ0XIivfXXLPUL2gaJiOSTH9QXiWcibuLKQmUO+
         Ufxov/4c+FvTDBEIIop0rgvfEbY+pGPjGUK9d5ErZ6XGLG4/pbnpuszEETz/7qj0Dl68
         7Z8fKXwYvfUW0OK6YbOngON7EmRMwaEQbEw/Fxe5GalMQqFS4+1nb+D1B/INupZNOEap
         MR3w==
X-Gm-Message-State: AOAM530OZq6hqe4jxXRRsA4krZdl6axWDkzPHj9oq4V+XuiShOGsF56X
        jq0h9Xj/zUgWyueT5Z8GagHW3MRg3Uj1nmO9zDuIVg==
X-Google-Smtp-Source: ABdhPJwKP4y+pemw61s5TPgupsrWMV3z9RQT2hiO6PBkW7Y2Z/NK3FR+aq2pE5vF0aYfenU9TlzVP4y+Z/XB4dnWHd8=
X-Received: by 2002:a05:6830:c9:: with SMTP id x9mr3343269oto.295.1614122346158;
 Tue, 23 Feb 2021 15:19:06 -0800 (PST)
MIME-Version: 1.0
References: <20210219144632.2288189-1-david.edmondson@oracle.com> <20210219144632.2288189-2-david.edmondson@oracle.com>
In-Reply-To: <20210219144632.2288189-2-david.edmondson@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 23 Feb 2021 15:18:54 -0800
Message-ID: <CALMp9eRCYvU6y4Nt6ZruHD+t2wkmkpd67Vhr-wGuD-36EmCMBw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: dump_vmcs should not assume
 GUEST_IA32_EFER is valid
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 19, 2021 at 6:46 AM David Edmondson
<david.edmondson@oracle.com> wrote:
>
> If the VM entry/exit controls for loading/saving MSR_EFER are either
> not available (an older processor or explicitly disabled) or not
> used (host and guest values are the same), reading GUEST_IA32_EFER
> from the VMCS returns an inaccurate value.
>
> Because of this, in dump_vmcs() don't use GUEST_IA32_EFER to decide
> whether to print the PDPTRs - do so if the EPT is in use and CR4.PAE
> is set.
>
> Fixes: 4eb64dce8d0a ("KVM: x86: dump VMCS on invalid entry")
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index eb69fef57485..818051c9fa10 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5759,7 +5759,6 @@ void dump_vmcs(void)
>         u32 vmentry_ctl, vmexit_ctl;
>         u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
>         unsigned long cr4;
> -       u64 efer;
>
>         if (!dump_invalid_vmcs) {
>                 pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
> @@ -5771,7 +5770,6 @@ void dump_vmcs(void)
>         cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
>         pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
>         cr4 = vmcs_readl(GUEST_CR4);
> -       efer = vmcs_read64(GUEST_IA32_EFER);
>         secondary_exec_control = 0;
>         if (cpu_has_secondary_exec_ctrls())
>                 secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
> @@ -5784,8 +5782,7 @@ void dump_vmcs(void)
>                cr4, vmcs_readl(CR4_READ_SHADOW), vmcs_readl(CR4_GUEST_HOST_MASK));
>         pr_err("CR3 = 0x%016lx\n", vmcs_readl(GUEST_CR3));
>         if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
> -           (cr4 & X86_CR4_PAE) && !(efer & EFER_LMA))
> -       {
> +           (cr4 & X86_CR4_PAE)) {

Assuming that we really want to restrict the printing of the PDPTEs, I
think you also need to test "cr0 & CR0.PG" (cf. section 26.3.1.6 of
the SDM, volume 3).
