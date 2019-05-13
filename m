Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D1A1BA82
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbfEMQBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729836AbfEMQBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:01:31 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2878F2168B
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557763290;
        bh=lEibKcwC5gVE6uqe1w9PcI6jNFCNtyn0TO/fffg8YH8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YBdQmFv+6f0ehcqPTdycmmzLGxIGw7o9OdfJad+Pew98TJbknjnEOFU5Ia677bZeP
         7yQRnNXKQ7beIL8WyMqISTgRWj+CyN9f5Tkextzwte6J/imWrq8bxznyj77y8IXwbR
         0OGW+acgJQTjsK+TkAhuAsfAx54+ZMBW+kf/71MQ=
Received: by mail-wm1-f52.google.com with SMTP id o189so14476379wmb.1
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 09:01:30 -0700 (PDT)
X-Gm-Message-State: APjAAAXE9aXoe63vgrghnxboJ68R+xrnzO4YkK2hcE1XtyjooYCHx5eS
        I68AL+QTWMqcHQsLPj8KxZ21IBRA/5oLVoZfM3bAtQ==
X-Google-Smtp-Source: APXvYqySeak5d5b75+WeyRRha6bI26hiE/9igsHZ0v7N1L8hvam3cM49nnezAxrIoHS1OAg32CScL++8+THXngeTOP8=
X-Received: by 2002:a7b:c844:: with SMTP id c4mr5457540wml.108.1557763286508;
 Mon, 13 May 2019 09:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com> <1557758315-12667-26-git-send-email-alexandre.chartre@oracle.com>
In-Reply-To: <1557758315-12667-26-git-send-email-alexandre.chartre@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 May 2019 09:01:14 -0700
X-Gmail-Original-Message-ID: <CALCETrWmvcrO0bBEw7iL-GnCED6hTz=FD+nANZkdQRo2R-w_3Q@mail.gmail.com>
Message-ID: <CALCETrWmvcrO0bBEw7iL-GnCED6hTz=FD+nANZkdQRo2R-w_3Q@mail.gmail.com>
Subject: Re: [RFC KVM 25/27] kvm/isolation: implement actual KVM isolation enter/exit
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 7:40 AM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
>
> From: Liran Alon <liran.alon@oracle.com>
>
> KVM isolation enter/exit is done by switching between the KVM address
> space and the kernel address space.
>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> ---
>  arch/x86/kvm/isolation.c |   30 ++++++++++++++++++++++++------
>  arch/x86/mm/tlb.c        |    1 +
>  include/linux/sched.h    |    1 +
>  3 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
> index db0a7ce..b0c789f 100644
> --- a/arch/x86/kvm/isolation.c
> +++ b/arch/x86/kvm/isolation.c
> @@ -1383,11 +1383,13 @@ static bool kvm_page_fault(struct pt_regs *regs, unsigned long error_code,
>         printk(KERN_DEFAULT "KVM isolation: page fault %ld at %pS on %lx (%pS) while switching mm\n"
>                "  cr3=%lx\n"
>                "  kvm_mm=%px pgd=%px\n"
> -              "  active_mm=%px pgd=%px\n",
> +              "  active_mm=%px pgd=%px\n"
> +              "  kvm_prev_mm=%px pgd=%px\n",
>                error_code, (void *)regs->ip, address, (void *)address,
>                cr3,
>                &kvm_mm, kvm_mm.pgd,
> -              active_mm, active_mm->pgd);
> +              active_mm, active_mm->pgd,
> +              current->kvm_prev_mm, current->kvm_prev_mm->pgd);
>         dump_stack();
>
>         return false;
> @@ -1649,11 +1651,27 @@ void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu)
>         kvm_isolation_exit();
>  }
>
> +static void kvm_switch_mm(struct mm_struct *mm)
> +{
> +       unsigned long flags;
> +
> +       /*
> +        * Disable interrupt before updating active_mm, otherwise if an
> +        * interrupt occurs during the switch then the interrupt handler
> +        * can be mislead about the mm effectively in use.
> +        */
> +       local_irq_save(flags);
> +       current->kvm_prev_mm = current->active_mm;

Peter's NAK aside, why on Earth is this in task_struct?  You cannot
possibly context switch while in isolation mode.

--Andy
