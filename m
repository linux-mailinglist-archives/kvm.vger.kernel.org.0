Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BAA3B6156
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 16:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbhF1Ofb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 10:35:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233720AbhF1Oca (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 10:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624890602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e5iye/ixu7FQ7xezRIk3x1grUzP9ni471MRjTDHPm9w=;
        b=iroa8Vv8v39aSU0S00gBYHn0hCDWH8JyGYE35+G2WLoel8+GWM+spBy3hVaYFAWdoYQ6Dt
        e/oAv+NoNv3Rb1AeBZpIm90VssINPqvWexbDFcLCX42BdV2XgHzOXoerUljr70wHXZou6q
        uXjDn7Kcedv7WKPTzWeBXn8WHI7iFQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-NNHEFzPvMgWvH0RDgTmw_w-1; Mon, 28 Jun 2021 10:30:00 -0400
X-MC-Unique: NNHEFzPvMgWvH0RDgTmw_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01C7D1083FA0;
        Mon, 28 Jun 2021 14:29:59 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A9C05B826;
        Mon, 28 Jun 2021 14:29:54 +0000 (UTC)
Message-ID: <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Stas Sergeev <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Date:   Mon, 28 Jun 2021 17:29:53 +0300
In-Reply-To: <20210628124814.1001507-1-stsp2@yandex.ru>
References: <20210628124814.1001507-1-stsp2@yandex.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-28 at 15:48 +0300, Stas Sergeev wrote:
> When returning to user, the special care is taken about the
> exception that was already injected to VMCS but not yet to guest.
> cancel_injection removes such exception from VMCS. It is set as
> pending, and if the user does KVM_SET_REGS, it gets completely canceled.
> 
> This didn't happen though, because the vcpu->arch.exception.injected
> and vcpu->arch.exception.pending were forgotten to update in
> cancel_injection. As the result, KVM_SET_REGS didn't cancel out
> anything, and the exception was re-injected on the next KVM_RUN,
> even though the guest registers (like EIP) were already modified.
> This was leading to an exception coming from the "wrong place".
> 
> This patch makes sure the vcpu->arch.exception.injected and
> vcpu->arch.exception.pending are in sync with the reality (and
> with VMCS). Also it adds clearing of pending exception to
> __set_sregs() the same way it is in __set_regs(). See patch
> b4f14abd9 that added it to __set_regs().
> 
> How to trigger the buggy scenario (that is, without this patch):
> - Make sure you have the old CPU where shadow page tables
> are used. Core2 family should be fine for the task. In this
> case, all PF exceptions produce the exit to monitor.
> - You need the _TIF_SIGPENDING flag set at the right moment
> to get kvm_vcpu_exit_request() to return true when the PF
> exception was just injected. In that case the cancel_injection
> path is executed.
> - You need the "unlucky" user-space that executes KVM_SET_REGS
> at the right moment. This leads to KVM_SET_REGS not clearing
> the exception, but instead corrupting its context.
> 
> v2 changes:
> - do not add WARN_ON_ONCE() to __set_regs(). As explained by
> Vitaly Kuznetsov, it can be user-triggerable.
> - clear pending exception also in __set_sregs().
> - update description with the bug-triggering scenario.

I used to know that area very very well, and I basically combed
the whole thing back and forth, 
and I have patch series to decouple injected and
pending exceptions. 

I'll refresh my memory on this and then I'll review your patch.

My gut feeling is that you discovered too that injections of
exceptions from userspace is kind of broken and only works
because Qemu doesn't really inject much (only some #MC exceptions
which are mostly fatal anyway, and #DB/#BP which only happen
when guest debugging is enabled which is not a standard feature).

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Stas Sergeev <stsp2@yandex.ru>
> 
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Sean Christopherson <seanjc@google.com>
> CC: Vitaly Kuznetsov <vkuznets@redhat.com>
> CC: Jim Mattson <jmattson@google.com>
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Jan Kiszka <jan.kiszka@siemens.com>
> CC: x86@kernel.org
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: kvm@vger.kernel.org
> ---
>  arch/x86/kvm/x86.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0f4a46649d7..d1026e9216e4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9450,7 +9450,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  cancel_injection:
>  	if (req_immediate_exit)
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
> -	static_call(kvm_x86_cancel_injection)(vcpu);
> +	if (vcpu->arch.exception.injected) {
> +		static_call(kvm_x86_cancel_injection)(vcpu);
> +		vcpu->arch.exception.injected = false;
> +		vcpu->arch.exception.pending = true;
> +	}
>  	if (unlikely(vcpu->arch.apic_attention))
>  		kvm_lapic_sync_from_vapic(vcpu);
>  out:
> @@ -10077,6 +10081,8 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  		pr_debug("Set back pending irq %d\n", pending_vec);
>  	}
>  
> +	vcpu->arch.exception.pending = false;
> +
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  
>  	ret = 0;


