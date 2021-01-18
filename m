Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4A2FA89D
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436830AbhARSVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:21:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436795AbhARSVc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 13:21:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610994005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Vv9nkzNfltlLY00eKJsJVQj3j7ro0rHB9RWEW1lqQc=;
        b=A998t5MpA/kPKrW8VUa03M+nNfGJRoQwqopcv6+11wPLantEtUx3/+5e+REDz4rOvIORzV
        9KxJ2elfWhzy42NxJpZKTYA91SvwvqcE1el6YR2TvGSHWhl9SLM7jwpAxnUFnSbp73rPM/
        JNsJSOQS2kUriE0Ttp3qMZ3ukcDz1Nk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-z4LNEgv2OCGeQgFoMKVZLA-1; Mon, 18 Jan 2021 13:20:04 -0500
X-MC-Unique: z4LNEgv2OCGeQgFoMKVZLA-1
Received: by mail-wr1-f70.google.com with SMTP id u14so8727857wrr.15
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 10:20:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Vv9nkzNfltlLY00eKJsJVQj3j7ro0rHB9RWEW1lqQc=;
        b=aDpohWwVyFfAf3V4FWupGO7ruGfOcl1I5LDwOum0zoY/NRXb8dl/CPgX/vlXqOutgG
         im04ZACQUjij4Jpj8sMlQfrM1Ri/JAN+eqaIRQUFel4LvFXbCio7TRzsFQc7DvnQ6p4i
         aUp6chnf3BLpmkzPRcvxJgshroz+hPZzpecrG7LtccVT4kR6/6DUXfrQZsoP4wmoOy6T
         VVluQh8+AELG5n0U3KhLK/oaqXpmnZ0xW3viVai72ljjDQ2UVQ7eB8ygcwqikI5BMbGg
         9+8sOJbNIhv+6xmY5Wsjiy8majprbRoKqKMTW6KM82LwC+10Zhtjy/WhiRqxMvDK2Odt
         2YJw==
X-Gm-Message-State: AOAM532FZFYp2/j5RN0otASprpqmUAb+LTzNwrfJnALGp37jop0zouUa
        qMcrMz8SA+96qEjTwN9SKdC4TbwE2QCa/23x5/jcKPxXpfbLOvjkY9D96MT7Wv+RmfAC31BOrmO
        9w34U7cXmbRrIWyTu5tLuZJw5k0xbx4aCcmQ8/gV5cShbTIWsQGPEL+tmnCAaIyyE
X-Received: by 2002:a05:6000:cc:: with SMTP id q12mr710307wrx.335.1610994002520;
        Mon, 18 Jan 2021 10:20:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwK+My+OWwDwzqEGQuVvdQmPIcEdwp+4o4OvNoFUAKAIfdP5OncVEc8+Uq2p28inp00XQKR8g==
X-Received: by 2002:a05:6000:cc:: with SMTP id q12mr710281wrx.335.1610994002296;
        Mon, 18 Jan 2021 10:20:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d7sm181036wmb.47.2021.01.18.10.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:20:01 -0800 (PST)
Subject: Re: [PATCH] kvm: tracing: Fix unmatched kvm_entry and kvm_exit events
To:     Dario Faggioli <dfaggioli@suse.com>, linux-kernel@vger.kernel.org
Cc:     Lorenzo Brescia <lorenzo.brescia@edu.unito.it>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
References: <160873470698.11652.13483635328769030605.stgit@Wayrath>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <59770b4e-0238-a1a4-83cb-77d36ff3b586@redhat.com>
Date:   Mon, 18 Jan 2021 19:20:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <160873470698.11652.13483635328769030605.stgit@Wayrath>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/20 15:45, Dario Faggioli wrote:
> From: Lorenzo Brescia <lorenzo.brescia@edu.unito.it>
> 
> On VMX, if we exit and then re-enter immediately without leaving
> the vmx_vcpu_run() function, the kvm_entry event is not logged.
> That means we will see one (or more) kvm_exit, without its (their)
> corresponding kvm_entry, as shown here:
> 
>   CPU-1979 [002] 89.871187: kvm_entry: vcpu 1
>   CPU-1979 [002] 89.871218: kvm_exit:  reason MSR_WRITE
>   CPU-1979 [002] 89.871259: kvm_exit:  reason MSR_WRITE
> 
> It also seems possible for a kvm_entry event to be logged, but then
> we leave vmx_vcpu_run() right away (if vmx->emulation_required is
> true). In this case, we will have a spurious kvm_entry event in the
> trace.
> 
> Fix these situations by moving trace_kvm_entry() inside vmx_vcpu_run()
> (where trace_kvm_exit() already is).
> 
> A trace obtained with this patch applied looks like this:
> 
>   CPU-14295 [000] 8388.395387: kvm_entry: vcpu 0
>   CPU-14295 [000] 8388.395392: kvm_exit:  reason MSR_WRITE
>   CPU-14295 [000] 8388.395393: kvm_entry: vcpu 0
>   CPU-14295 [000] 8388.395503: kvm_exit:  reason EXTERNAL_INTERRUPT
> 
> Of course, not calling trace_kvm_entry() in common x86 code any
> longer means that we need to adjust the SVM side of things too.
> 
> Signed-off-by: Lorenzo Brescia <lorenzo.brescia@edu.unito.it>
> Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
> ---
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: kvm@vger.kernel.org
> Cc: Lorenzo Brescia <lorenzo.brescia@edu.unito.it>
> Cc: Dario Faggioli <dfaggioli@suse.com>
> ---
>   arch/x86/kvm/svm/svm.c |    2 ++
>   arch/x86/kvm/vmx/vmx.c |    2 ++
>   arch/x86/kvm/x86.c     |    3 +--
>   3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cce0143a6f80..ed272fcf6495 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3741,6 +3741,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> +	trace_kvm_entry(vcpu);
> +
>   	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
>   	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
>   	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 75c9c6a0a3a4..ff20f9e6e5b3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6653,6 +6653,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   	if (vmx->emulation_required)
>   		return EXIT_FASTPATH_NONE;
>   
> +	trace_kvm_entry(vcpu);
> +
>   	if (vmx->ple_window_dirty) {
>   		vmx->ple_window_dirty = false;
>   		vmcs_write32(PLE_WINDOW, vmx->ple_window);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3f7c1fc7a3ce..a79666204907 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8973,8 +8973,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   		kvm_x86_ops.request_immediate_exit(vcpu);
>   	}
>   
> -	trace_kvm_entry(vcpu);
> -
>   	fpregs_assert_state_consistent();
>   	if (test_thread_flag(TIF_NEED_FPU_LOAD))
>   		switch_fpu_return();
> @@ -11538,6 +11536,7 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>   }
>   EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>   
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> 
> 

Qeuued, thanks!

Paolo

