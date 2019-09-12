Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40BBB15D2
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 23:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbfILVUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 17:20:22 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33433 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbfILVUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 17:20:22 -0400
Received: by mail-io1-f68.google.com with SMTP id m11so58338930ioo.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 14:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gN6NbTbdBD+LpPm2/OIojga+N97BltFjeiskUToQd2k=;
        b=uwudzUW+QhHWEBiuzAIQHoFP9Q69nPzDa6YfPHDIQwbLPH4yOueCxKLHSe10rBJGk/
         KhMtM3sJArrKR7vuHq9nkIr2X+tNYnC7SsyfPUc8rTLoktXUYE+BXhGSdYy2FvVSDgOQ
         yKNYiKfgP1dIJeZSY5aAox8IvqunDL6EsO+02vs0RyvDv4sJ7r5Dd/0RqA51abO/h0vM
         TCAQ2atBaRXIorzCzX0TzVQ/DQaJZZRQIuFIBjS6v+n/Z7h+n5wXwcUqzBUU0Q/AgtPG
         Upc37wSeXinGGYRHaEyBVQFkRHDAnyZe22+DLDbAwn8sjLRfhktzooI2nSXj1XC5rISB
         vpUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gN6NbTbdBD+LpPm2/OIojga+N97BltFjeiskUToQd2k=;
        b=bWKJIakz3kLRLN3UyGXd9502fcSE4KIY2cuDqw2DUToMgZ0uruCk8R0yh0opTI0J55
         k0SMClTvMoagDfsve81SQyYwr/Un79OAcwYySo/b85EB2ezBrRjkBEqfUyHscvwU9fDG
         RPi654s0d1xIT3M6KMJW3s66cMo0aevkeOBSN9g/EsoRJaNLSOYeudPMrjVRTDQYM1zO
         Rb5X4nWbMz4wwExSwZS7ydbOxkJL1caPtmfv4GWP9SKiBcb/5vWS3YXDFMJgS2xVWjOp
         tUSf4HDelY8z4xnaszWmhchaeYvC8SKpwVtxfTxgar4gRq10lXAiCpEsYqlDZuNTwhTu
         aRSA==
X-Gm-Message-State: APjAAAWPqzBXFqZOfZKeIKgRt/cxITebtJojQfiAmjw+Pxa/XW8x2ypP
        pAD/UtCCxDhpMp6RbwmEClCSiuHhIUIp97hlE5DV7Q==
X-Google-Smtp-Source: APXvYqwxoYarrCqiyOJMszrAlELGJkKpICOdAogSDotKra7i4hK6Vfwg5TYlNK0oSP4qThk1xhrf5PPbSUlOsmz3LX0=
X-Received: by 2002:a6b:1606:: with SMTP id 6mr2231217iow.108.1568323220804;
 Thu, 12 Sep 2019 14:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190912041817.23984-1-huangfq.daxian@gmail.com>
In-Reply-To: <20190912041817.23984-1-huangfq.daxian@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Sep 2019 14:20:09 -0700
Message-ID: <CALMp9eSL_rDdWmgeWNwuqP_J_yu7x5Gs8DUBpJFdie18NEz=ow@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: work around leak of uninitialized stack contents
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 9:18 PM Fuqian Huang <huangfq.daxian@gmail.com> wrote:
>
> Emulation of VMPTRST can incorrectly inject a page fault
> when passed an operand that points to an MMIO address.
> The page fault will use uninitialized kernel stack memory
> as the CR2 and error code.
>
> The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
> exit to userspace; however, it is not an easy fix, so for now just ensure
> that the error code and CR2 are zero.
>
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> ---
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 290c3c3efb87..7f442d710858 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5312,6 +5312,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
>         /* kvm_write_guest_virt_system can pull in tons of pages. */
>         vcpu->arch.l1tf_flush_l1d = true;
>
> +       memset(exception, 0, sizeof(*exception));
>         return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
>                                            PFERR_WRITE_MASK, exception);
>  }
> --
> 2.11.0
>
Perhaps you could also add a comment like the one Paolo added when he
made the same change in kvm_read_guest_virt?
See commit 353c0956a618 ("KVM: x86: work around leak of uninitialized
stack contents (CVE-2019-7222)").
