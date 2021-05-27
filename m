Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CDC392E6D
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 14:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhE0M5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:57:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235811AbhE0M5f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 08:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622120162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mjDjSQfgt4N66fzwKVYLXkqIe/sfqAKrR+Cjf7Vsstw=;
        b=UoYTIoXhv9ihWsZKO5Y4XrQzkOg4dFQY6T2No0cl991TbUUOcsIg11n51MOC01nPOjgO7N
        GkKfTLW6KzmS3D3f3RF6fR7ipwS8O7gsaR4anWjZWysdzj4XemRIwj0eiSJd7g6K1ANwV+
        ALfr0mWwDYJGcnarAZ4NWTw9aRXx3KI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-ZmmJ052nMsCyyra0L7xHvQ-1; Thu, 27 May 2021 08:56:00 -0400
X-MC-Unique: ZmmJ052nMsCyyra0L7xHvQ-1
Received: by mail-ej1-f71.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so1638607ejw.22
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 05:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mjDjSQfgt4N66fzwKVYLXkqIe/sfqAKrR+Cjf7Vsstw=;
        b=c7Ecrwt8qIvcz8ay+CG83RTGwYkgJVNHfWRmjw2NgK9HZeREGfagSIPviAhohRNNGn
         LIr6UFpK/vx7gMFpuMUy9LXTgMJxdCHSeqSeeS1JJ4H5sKMSVyZQp/1dRH+HD9TZWVbC
         LoxnZOJaabH2ntLp+5hH1rfvqZ4j4kmyG38D6AUgY28mF48cpK2Bkyh5mao9Y2gHfPUc
         yu3G2zJFLcgocreVxaSGbH47g01LHrgDEqeEGN4oE0TRPQrW/yGmdtnjt8I3GUk86Mve
         MPntDxLMy/2K3qea2rrm6Q/GMKW2vfIVEUlrjbVIj9gPbSjPHeaITS7SpZfOtx0llsRx
         1u1Q==
X-Gm-Message-State: AOAM531t8hqKO0r7VFt46/hLC5f7H/fgEXEnAjS/PXieBjtasUGtCVxx
        9RPN1QdeyZ+lzLArQSi9JbSoDzhlB3QKZC3J4+l6A6prQnNj+lpox0HFaH0GzLG5niqoWm4jcs7
        ngPki7y9B3XixqsJ4IB5hsU5nZ8DnIYax/DvoS5MR+HeBCx4pehKqkifa3iG5Ck5X
X-Received: by 2002:a17:906:7196:: with SMTP id h22mr3666778ejk.50.1622120158607;
        Thu, 27 May 2021 05:55:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfI9NMKAFexq0oe8zJSjqeobKTswha4YBrHP5ftbNdDrClxzRK0MsRZz0vHafsIq2ojkIjAQ==
X-Received: by 2002:a17:906:7196:: with SMTP id h22mr3666740ejk.50.1622120158355;
        Thu, 27 May 2021 05:55:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v12sm824871edy.75.2021.05.27.05.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 05:55:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
Date:   Thu, 27 May 2021 14:55:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210527023922.2017-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/21 04:39, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> For KVM_VCPU_FLUSH_TLB used in kvm_flush_tlb_multi(), the guest expects
> the hypervisor do the operation that equals to native_flush_tlb_global()
> or invpcid_flush_all() in the specified guest CPU.
> 
> When TDP is enabled, there is no problem to just flush the hardware
> TLB of the specified guest CPU.
> 
> But when using shadowpaging, the hypervisor should have to sync the
> shadow pagetable at first before flushing the hardware TLB so that
> it can truely emulate the operation of invpcid_flush_all() in guest.

Can you explain why?

Also it is simpler to handle this in kvm_vcpu_flush_tlb_guest, using "if 
(tdp_enabled).  This provides also a single, good place to add a comment 
with the explanation of what invalid entries KVM_REQ_RELOAD is presenting.

Paolo

> The problem exists since the first implementation of KVM_VCPU_FLUSH_TLB
> in commit f38a7b75267f ("KVM: X86: support paravirtualized help for TLB
> shootdowns").  But I don't think it would be a real world problem that
> time since the local CPU's tlb is flushed at first in guest before queuing
> KVM_VCPU_FLUSH_TLB to other CPUs.  It means that the hypervisor syncs the
> shadow pagetable before seeing the corresponding KVM_VCPU_FLUSH_TLBs.
> 
> After commit 4ce94eabac16 ("x86/mm/tlb: Flush remote and local TLBs
> concurrently"), the guest doesn't flush local CPU's tlb at first and
> the hypervisor can handle other VCPU's KVM_VCPU_FLUSH_TLB earlier than
> local VCPU's tlb flush and might flush the hardware tlb without syncing
> the shadow pagetable beforehand.
> 
> Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>   arch/x86/kvm/vmx/vmx.c |  8 +++++++-
>   2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 05eca131eaf2..f4523c859245 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3575,6 +3575,20 @@ void svm_flush_tlb(struct kvm_vcpu *vcpu)
>   		svm->current_vmcb->asid_generation--;
>   }
>   
> +static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * When NPT is enabled, just flush the ASID.
> +	 *
> +	 * When NPT is not enabled, the operation should be equal to
> +	 * native_flush_tlb_global(), invpcid_flush_all() in guest.
> +	 */
> +	if (npt_enabled)
> +		svm_flush_tlb(vcpu);
> +	else
> +		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> +}
> +
>   static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4486,7 +4500,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.tlb_flush_all = svm_flush_tlb,
>   	.tlb_flush_current = svm_flush_tlb,
>   	.tlb_flush_gva = svm_flush_tlb_gva,
> -	.tlb_flush_guest = svm_flush_tlb,
> +	.tlb_flush_guest = svm_flush_tlb_guest,
>   
>   	.run = svm_vcpu_run,
>   	.handle_exit = handle_exit,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bceb5ca3a89..1913504e3472 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3049,8 +3049,14 @@ static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
>   	 * are required to flush GVA->{G,H}PA mappings from the TLB if vpid is
>   	 * disabled (VM-Enter with vpid enabled and vpid==0 is disallowed),
>   	 * i.e. no explicit INVVPID is necessary.
> +	 *
> +	 * When EPT is not enabled, the operation should be equal to
> +	 * native_flush_tlb_global(), invpcid_flush_all() in guest.
>   	 */
> -	vpid_sync_context(to_vmx(vcpu)->vpid);
> +	if (enable_ept)
> +		vpid_sync_context(to_vmx(vcpu)->vpid);
> +	else
> +		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
>   }
>   
>   void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu)
> 

