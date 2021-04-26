Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9751436B0B1
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhDZJeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbhDZJeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 05:34:25 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9722AC061574;
        Mon, 26 Apr 2021 02:33:42 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a11so2922935ioo.0;
        Mon, 26 Apr 2021 02:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnDdhSfghxdgBT4hhRmyjFVZ+eM7uoJ7RMVHwKGzfIE=;
        b=A0JZgblxaHFBYPpfTBYLv7RrLxerkuPHoZeI+AXHFYMalWqHubI6RPlEvlDAL2OhhV
         IIcFc6uiH98t2EepKLdTZIubzd4lUW+N/oCJw/i+1rQR2ERhtgry5TfHuOxJXPHNVHPo
         Dapk/ouovvl4SqgcGUN9pre4Wqom/Z5xFEGO6CqWE2vqWDPLyOUoJupzAyT0CijxPB2t
         kqPA1mHmqb7AkwUonuCIA9ZFUaom7sEpvlW5kt69jjk43t9GeWnQHIKcbUs/NTYEOriW
         CT+Tig5ptvv/NNA8mRSXPlPjP+oVlQ3/C3EM0g+1Am4Mi+0BegGm0NbjdUcQQR5u7xiM
         zxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnDdhSfghxdgBT4hhRmyjFVZ+eM7uoJ7RMVHwKGzfIE=;
        b=IsGtzWIsc9JdEINBuBYavUespJ5ayFzU/ehJ4wUdx05Pd9URXMaauPsRCG+zNPhoJ3
         No7b//IBb7JeHy2gic6T0+tckVKikIAPZoYxKzbOmieXqZRVbg3/ayiVF0+BshcXMqAs
         e+B8VcXEy2r2YhNO3pmqnrjPZoY0eYrSd5JBcdBVPgARu2QM/acg16OSUqc7Rm2dcrTm
         pAELF8JRenVnZBM4OpoI6aRakqIaBZeSz898zRBtygYomd9eZu1iQflJ++artwBgPf5K
         KzXQj5yh5asaBxUdmW3vpthLb5sZSe5YaRLqIRbG4X5fYBqhMpVmmslRVM9y7yoQMRrF
         8IHA==
X-Gm-Message-State: AOAM531Oh3/747v0hVQ82Hny3GXVM/NeC2L9hLM+zUvlRuJRu/PuZ4sA
        4X6Mm/cM/V35rqBav0JBj9bRIUne83r7HwW0RE0=
X-Google-Smtp-Source: ABdhPJy/nZrXcfLUoI1ikGjhjLdyu8YTa0BkZH5/i9Nr2Koi3j1QPg1Ey3UY56DThePnVVDQ9InMtE12++e3VnhHTtI=
X-Received: by 2002:a6b:b404:: with SMTP id d4mr13662921iof.56.1619429622159;
 Mon, 26 Apr 2021 02:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200915191505.10355-1-sean.j.christopherson@intel.com> <20200915191505.10355-3-sean.j.christopherson@intel.com>
In-Reply-To: <20200915191505.10355-3-sean.j.christopherson@intel.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Mon, 26 Apr 2021 17:33:30 +0800
Message-ID: <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call
 instead of INTn
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CC: Andy Lutomirski
Add CC: Steven Rostedt

I think this patch made it wrong for NMI.

On Wed, Sep 16, 2020 at 3:27 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Rework NMI VM-Exit handling to invoke the kernel handler by function
> call instead of INTn.  INTn microcode is relatively expensive, and
> aligning the IRQ and NMI handling will make it easier to update KVM
> should some newfangled method for invoking the handlers come along.
>
> Suggested-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 391f079d9136..b0eca151931d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6411,40 +6411,40 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>
>  void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
>
> +static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
> +{
> +       unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> +       gate_desc *desc = (gate_desc *)host_idt_base + vector;
> +
> +       kvm_before_interrupt(vcpu);
> +       vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
> +       kvm_after_interrupt(vcpu);
> +}
> +
>  static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  {
>         u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
>
>         /* if exit due to PF check for async PF */
> -       if (is_page_fault(intr_info)) {
> +       if (is_page_fault(intr_info))
>                 vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
>         /* Handle machine checks before interrupts are enabled */
> -       } else if (is_machine_check(intr_info)) {
> +       else if (is_machine_check(intr_info))
>                 kvm_machine_check();
>         /* We need to handle NMIs before interrupts are enabled */
> -       } else if (is_nmi(intr_info)) {
> -               kvm_before_interrupt(&vmx->vcpu);
> -               asm("int $2");
> -               kvm_after_interrupt(&vmx->vcpu);
> -       }
> +       else if (is_nmi(intr_info))
> +               handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
>  }

When handle_interrupt_nmi_irqoff() is called, we may lose the
CPU-hidden-NMI-masked state due to IRET of #DB, #BP or other traps
between VMEXIT and handle_interrupt_nmi_irqoff().

But the NMI handler in the Linux kernel *expects* the CPU-hidden-NMI-masked
state is still set in the CPU for no nested NMI intruding into the beginning
of the handler.

The original code "int $2" can provide the needed CPU-hidden-NMI-masked
when entering #NMI, but I doubt it about this change.

I maybe missed something, especially I haven't read all of the earlier
discussions about the change.  More importantly, I haven't found the original
suggestion from Andi Kleen: (Quote from the cover letter):

The NMI consolidation was loosely suggested by Andi Kleen.  Andi's actual
suggestion was to export and directly call the NMI handler, but that's a
more involved change (unless I'm misunderstanding the wants of the NMI
handler), whereas piggybacking the IRQ code is simple and seems like a
worthwhile intermediate step.
(End of quote)

I think we need to change it back or change it to call the NMI handler
immediately after VMEXIT before leaving "nostr" section if needed.

Thanks,
Lai
