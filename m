Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206FE9F305
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 21:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfH0TND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 15:13:03 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44384 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730347AbfH0TND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 15:13:03 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so663133iog.11
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 12:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQJxEYUXnqkOd54ze0iIvNMwGeKfFiBDRd0wcO9eWqU=;
        b=igzHCTGUm2FIXir7Dgwr+iAIiv0yRzYRHwvNq3FJv8G+f8PTq8a3cEkP/flze0PhxX
         +kClsdGCmWfeOe6vb7Q+AfHhBvICvTcSsfm0PryjDTYNTb7xXsarhieOYcUl/Bny8mVz
         801aUYeI6Bc2lpTY8CUWoyTchr0aCrEOUhZFTxRbsfDw6iY7/eabs8t3yYUdPiok1BdO
         hm7teUDadvyFKWlIP1bWX9k5A2Ub2Ui5owwP4M8JM61q779G4T/qQWR6xvgSjKfGo1Ma
         HhIN8Lfhub7wzi+EBSX0Amd8REw9JvzhbVdvTbcsYEBPm0n0kY8n8TD1Wgn3UhkGfcXm
         vfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQJxEYUXnqkOd54ze0iIvNMwGeKfFiBDRd0wcO9eWqU=;
        b=h56H5IPvQHddoq73FntnOeWUS3gVj1NOk+84MbB6t/YalGKBtdkYkz67Lk/qEv7H5l
         fCh3k6wMzw6qSt2L/FmhfgAFMMd9jTU9E7VkMMfAPanZ466apjhMkJdMf3sGY3nJQx8J
         NsQtQ+zqMSlomKuId/t/pkI0loIWUSKgM8HcXcDOqVdO0mjrXrcVNX29OQEGChtHPAVd
         FQI4EblPXyzL+aAfjsed1wSgRFhHp2UfHFfiA+q8lkWeBRfWM6MQ6O9NPB7bwOYtefA8
         KS185gCsZ8uhKRJITBWyB8xL2jwV+/U8tAfEfqrhciZegWZftw+cZ3IRp8MOPOUSmI3w
         jrwQ==
X-Gm-Message-State: APjAAAWpSXvErlsd2EX4Xaf9nJVsdPMc9JWlcgzPY2lpduOW6qC6C9HU
        jqLW22ygAkdlsy2ikgBfaNlllGS3cT/j1hJ0FQfTTg==
X-Google-Smtp-Source: APXvYqzbQzeTcca6N5+3PhjjFP7J6N1VvGjJla1JyuPmLZHf9fNsWCmlU3bY67zfwgYTIvsTzYaEYd0Hn2NWk6j1T0g=
X-Received: by 2002:a5e:8f4d:: with SMTP id x13mr191724iop.118.1566933182198;
 Tue, 27 Aug 2019 12:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190823205544.24052-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190823205544.24052-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Aug 2019 12:12:51 -0700
Message-ID: <CALMp9eSwxTdigRkACRgr=avg8HZh+gPXgPnwd7+CaNEEuS2tQA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Don't update RIP or do single-step on faulting emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 1:55 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Don't advance RIP or inject a single-step #DB if emulation signals a
> fault.  This logic applies to all state updates that are conditional on
> clean retirement of the emulation instruction, e.g. updating RFLAGS was
> previously handled by commit 38827dbd3fb85 ("KVM: x86: Do not update
> EFLAGS on faulting emulation").
>
> Not advancing RIP is likely a nop, i.e. ctxt->eip isn't updated with
> ctxt->_eip until emulation "retires" anyways.  Skipping #DB injection
> fixes a bug reported by Andy Lutomirski where a #UD on SYSCALL due to
> invalid state with RFLAGS.RF=1 would loop indefinitely due to emulation
> overwriting the #UD with #DB and thus restarting the bad SYSCALL over
> and over.
>
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Cc: stable@vger.kernel.org
> Reported-by: Andy Lutomirski <luto@kernel.org>
> Fixes: 663f4c61b803 ("KVM: x86: handle singlestep during emulation")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> Note, this has minor conflict with my recent series to cleanup the
> emulator return flows[*].  The end result should look something like:
>
>                 if (!ctxt->have_exception ||
>                     exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
>                         kvm_rip_write(vcpu, ctxt->eip);
>                         if (r && ctxt->tf)
>                                 r = kvm_vcpu_do_singlestep(vcpu);
>                         __kvm_set_rflags(vcpu, ctxt->eflags);
>                 }
>
> [*] https://lkml.kernel.org/r/20190823010709.24879-1-sean.j.christopherson@intel.com
>
>  arch/x86/kvm/x86.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4cfd786d0b6..d2962671c3d3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6611,12 +6611,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>                 unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
>                 toggle_interruptibility(vcpu, ctxt->interruptibility);
>                 vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
> -               kvm_rip_write(vcpu, ctxt->eip);
> -               if (r == EMULATE_DONE && ctxt->tf)
> -                       kvm_vcpu_do_singlestep(vcpu, &r);
>                 if (!ctxt->have_exception ||
> -                   exception_type(ctxt->exception.vector) == EXCPT_TRAP)
> +                   exception_type(ctxt->exception.vector) == EXCPT_TRAP) {

NYC, but...

I don't think this check for "exception_type" is quite right.  A
general detect fault (which can be synthesized by check_dr_read) is
mischaracterized by exception_type() as a trap. Or maybe I'm missing
something? (I often am.)

> +                       kvm_rip_write(vcpu, ctxt->eip);
> +                       if (r == EMULATE_DONE && ctxt->tf)
> +                               kvm_vcpu_do_singlestep(vcpu, &r);
>                         __kvm_set_rflags(vcpu, ctxt->eflags);
> +               }
>
>                 /*
>                  * For STI, interrupts are shadowed; so KVM_REQ_EVENT will
> --
> 2.22.0
>
